import java.sql.*;
import java.io.*;
import java.util.*;
//import java.io.FileInputStream;
//import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class DataLoadPipeline {

	
	static final int META_INDEX = 0;
	static final int GAS_INDEX = 1;
	static final int DARK_INDEX = 2;
	static final int STAR_INDEX = 3;
	
	public static void main(String[] args) throws Exception {
		
		// input tipsy file
			// -f <filename>
		// iOrder file
			// -iord <filename>
		// type(s) of particle to load / print header
			// -star | -gas | -dark | -all | -print
		// db host, (port), user name
			// -host <hostname>
			// -u <username>
			// -p <password>
		// table name / create table first?
			// -table <tablename> | -create <tablename>
		// (config file)
		//usage();
		int i = 0;
//		boolean createTable = false;
//		boolean star = false;
//		boolean gas = false;
//		boolean dark = false;
		boolean printHeader = false;
		//String tipsyFile, iordFile, hostName, userName, password/*, starTableName, gasTableName, darkTableName*/;
		String tipsyFile = null, iordFile = null, hostName = null, userName = null, password = null;
		for ( ; i < args.length; ++i ) {
			if ( args[i].charAt(0) != '-' ) {
				usage();
				System.exit(1);
			} if ( "-f".equals(args[i]) ) {
				tipsyFile = args[++i];
			} else if ( "-iord".equals(args[i]) ) {
				iordFile = args[++i];
			} else if ( "-print".equals(args[i]) ) {
				printHeader = true;
			} else if ( "-host".equals(args[i]) ) {
				hostName = args[++i];
			} else if ( "-u".equals(args[i]) ) {
				userName = args[++i];
			} else if ( "-p".equals(args[i]) ) {
				password = args[++i];
			} else {
				System.err.println("Unknown option: "+args[i]);
				usage();
				System.exit(1);
			}
		}
		//Process the open iOrd file
		Scanner iOrdInput = new Scanner(new File(iordFile));
		int totalParticleNum = iOrdInput.nextInt();
		
//		//Set up for reading buffer
//		if (args.length != 1) {
//			System.err.println("Usage: Java DataLoadPipline <tipsyfile>");
//			System.exit(1);
//		}
//		String file = args[0];
		String file = tipsyFile;
		
		
		FileInputStream fis = new FileInputStream(file);
		FileChannel fc = fis.getChannel();
		ByteBuffer buffer = ByteBuffer.allocate(32);
		
		if (fc.read(buffer) == -1) {
			System.err.println("Error reading from in-channel");
			System.exit(1);
		}
		// Flip buffer 
		buffer.flip();
		// Get 4 padding bytes
		buffer.getInt();
		float time = buffer.getFloat();
		int ndim = buffer.getInt();
		int ntot = buffer.getInt();
		int ngas = buffer.getInt();
		int ndark = buffer.getInt();
		int nstar = buffer.getInt();
		buffer.getInt();
		System.out.println("time:\t" + time + "\nndim:\t" + ndim +  "\nntot:\t" + ntot + "\nngas:\t" + ngas + "\nndark:\t" + ndark + "\nnstar\t" + nstar);
		buffer.clear();
		
		//Check iOrdNum and ntot num and make sure they are the same
		if (totalParticleNum != ntot)
			System.out.println("Warning! The iOrd total particle number is " +
					"different from the ntot in the tipsy file!!");
		
		// Process gas particles
		String tableNameGas = "wtltest_GasJava";
		String tableNameDark = "wtltest_DarkJava";
		String tableNameStar = "wtltest_StarJava";
		String tableNameAll = "wtltest_AllJava";
		
		if (!printHeader) {
			//To initialize Database connection string
			DB db = new DB();

			//Set up for db connection
			//		Connection con = db.dbConnect("jdbc:jtds:sqlserver://fatboy.npl.washington.edu/NBODY", "NBODY-1", "TheWholeNchilada!");
			Connection con = db.dbConnect("jdbc:jtds:sqlserver://"+hostName, userName, password);

			//create tables for the different particles
			db.createTablesGas(con, tableNameGas); //create gas table
			db.createTablesDark(con, tableNameDark); //create dark table
			db.createTablesStar(con, tableNameStar); //create star table
			
			//create table for all particle
			db.createTableAll(con, tableNameAll);


			//Create prepared statements for bulk insertion
			db.prepareGasStatement(con, tableNameGas);
			db.prepareDarkStatement(con, tableNameDark);
			db.prepareStarStatement(con, tableNameStar);
			
			//Create prepared statements for all particles for bulk insertion
			db.prepareAllStatement(con, tableNameAll);

			buffer = ByteBuffer.allocate(48); //bump it to 4 mb
			insertGas(con, buffer, fc, ngas, db, iOrdInput);

			//		insertMeta();
			//inserted this much data: 1572864
			//Insertion (dark) took 67006ms

			buffer = ByteBuffer.allocate(36);
			insertDark(con, buffer, fc, ndark, db, iOrdInput);

			buffer = ByteBuffer.allocate(44);
			insertStar(con, buffer, fc, nstar, db, iOrdInput);


			//		db.createTablesMeta(con, "wtltest_metaJava");
			//		db.insertDataDark(con, "wtltest_DarkJava", 2097152, (float)1.07765e-07, (float)-0.477565, (float)-0.446872, 
			//				(float)-0.45568, (float)0.100956, (float)0.057776, (float)0.0266779, (float)-0.113261, (float)9.6e-06);
			//		db.insertDataGas(con, "wtltest_GasJava", 50, 55, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
			//		db.insertDataStar(con, "wtltest_StarJava", 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
			//		db.insertDataMeta(con, "wtltest_metaJava", 5, 333, 50, 50, 50, 50);
			db.dbClose(con);
			System.out.println("Connected, but now exiting, goodbye.");
		}
	}

	private static void usage() {

		System.out.println("USAGE:");
		System.out.println("java DataLoadPipeline.jar -f <TIPSY_Binary_File> -iord <iOrder_file.iord> [ -print ]");
		System.out.println("        -host <Host_Name> -u <User_Name> -p <Password>");
		System.out.println("    -- Load a TIPSY file with iOrder into the specified database.");
		System.out.println("    -- The optional -print tells the program to print headers from TIPSY file without importing data");
		System.out.println("    -- <Host_Name> specifies the server to which the data is imported.");
		System.out.println("    -- <User_Name> and <Password> specifies the login of the server.");
	}
	
	private static void insertStar(Connection con, ByteBuffer buffer, FileChannel fc, int nstar, DB db, Scanner iOrdInput) throws IOException {
		long s,t;
		s = System.currentTimeMillis();
		for (int i = 0; i < nstar; i++) {
			if (fc.read(buffer) == -1) {
				System.err.println("Error: unexpected EOF");
				System.out.println("inserted this much data: " + i);
				break;
				//System.exit(1);
			}
			if (i % 9999 == 0) {
				//System.out.println("Now at " + i);
				db.executePreparedStatement(con, STAR_INDEX);
			}
				
			//get nextIordID
			int iOrdNum = iOrdInput.nextInt();
			//Now get values from tipsy file
			buffer.flip();
			float mass = buffer.getFloat();
			float x = buffer.getFloat();
			float y = buffer.getFloat();
			float z = buffer.getFloat();
			float vx = buffer.getFloat();
			float vy = buffer.getFloat();
			float vz = buffer.getFloat();
			float phi = buffer.getFloat();
			float metals = buffer.getFloat();
			float tform = buffer.getFloat();
			float eps = buffer.getFloat();
			db.insertStarPrepared(con, iOrdNum, mass, x, y, z, vx, vy, vz, phi, metals, tform, eps);	
			buffer.clear();
		}
		db.executePreparedStatement(con, STAR_INDEX);
		db.closePreparedStatement(con, STAR_INDEX);
		t = System.currentTimeMillis();
		System.out.println("Insertion (star) took " + (t-s) + "ms");
	}

	private static void insertDark(Connection con, ByteBuffer buffer, FileChannel fc, int ndark, DB db, Scanner iOrdInput) throws IOException {
		long s,t;
		s = System.currentTimeMillis();
		for (int i = 0; i < ndark; i++) {
			if (fc.read(buffer) == -1) {
				System.err.println("Error: unexpected EOF");
//				System.exit(1);
				System.out.println("inserted this much data: " + i);
				break;
			}
			if (i % 9999 == 0) {
				//System.out.println("Now at " + i);
				db.executePreparedStatement(con, DARK_INDEX);
			}
				
			//get nextIordID
			int iOrdNum = iOrdInput.nextInt();
			//Now get values from tipsy file
			buffer.flip();
			float mass = buffer.getFloat();
			float x = buffer.getFloat();
			float y = buffer.getFloat();
			float z = buffer.getFloat();
			float vx = buffer.getFloat();
			float vy = buffer.getFloat();
			float vz = buffer.getFloat();
			float phi = buffer.getFloat();
			float eps = buffer.getFloat();
			db.insertDarkPrepared(con, iOrdNum, mass, x, y, z, vx, vy, vz, phi, eps);	
			buffer.clear();
		}
		db.executePreparedStatement(con, DARK_INDEX);
		db.closePreparedStatement(con, DARK_INDEX);
		t = System.currentTimeMillis();
		System.out.println("Insertion (dark) took " + (t-s) + "ms");
		
	}

	private static void insertGas(Connection con, ByteBuffer buffer, FileChannel fc, int ngas, DB db, Scanner iOrdInput) throws IOException {
		long s,t;
		s = System.currentTimeMillis();
		for (int i = 0; i < ngas; i++) {
			if (fc.read(buffer) == -1) {
				System.err.println("Error: unexpected EOF");
				System.out.println("inserted this much data: " + i);
				break;
				//System.exit(1);
			}
			if (i % 9999 == 0) {
//				System.out.println("Now at " + i);
				db.executePreparedStatement(con, GAS_INDEX);
			}
			
			//get nextIordID
			int iOrdNum = iOrdInput.nextInt();
			//Now get values from tipsy file
			buffer.flip();
			float mass = buffer.getFloat();
			float x = buffer.getFloat();
			float y = buffer.getFloat();
			float z = buffer.getFloat();
			float vx = buffer.getFloat();
			float vy = buffer.getFloat();
			float vz = buffer.getFloat();
			float rho = buffer.getFloat();
			float temp = buffer.getFloat();
			float hsmooth = buffer.getFloat();
			float metals = buffer.getFloat();
			float phi = buffer.getFloat();
			db.insertGasPrepared(con, iOrdNum, mass, x, y, z, vx, vy, vz, phi, rho, temp, hsmooth, metals);
			buffer.clear();
		}
		db.executePreparedStatement(con, GAS_INDEX);
		db.closePreparedStatement(con, GAS_INDEX);
		t = System.currentTimeMillis();
		//test(using individual insert) took 2604100ms = 43.40167 minutes
		//test2 (using bulk insert and prepared statements) took 96334 ms = 1.60556667 minutes
		System.out.println("Insertion (gas) took " + (t-s) + "ms");

		
	}

//	private static void insertMeta() {
//		// TODO Auto-generated method stub
//		
//	}
}
