import java.sql.*;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class DataLoadPipeline {

	
	static final int META_INDEX = 0;
	static final int GAS_INDEX = 1;
	static final int DARK_INDEX = 2;
	static final int STAR_INDEX = 3;
	
	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		System.out.println("Welcome to DataLoadPipeline");
		System.out.println("This is just a test");
		DB db = new DB();
		
		
		//Set up for db connection
		Connection con = db.dbConnect("jdbc:jtds:sqlserver://fatboy.npl.washington.edu/NBODY", "NBODY-1", "TheWholeNchilada!");
		
		//Set up for reading buffer
		if (args.length != 1) {
			System.err.println("Usage: Java DataLoadPipline <tipsyfile>");
			System.exit(1);
		}
		String file = args[0];
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
		
		
		// Process gas particles
		String tableNameGas = "wtltest_GasJava";
		String tableNameDark = "wtltest_DarkJava";
		String tableNameStar = "wtltest_StarJava";
		
		//create tables for the different particles
		db.createTablesGas(con, tableNameGas); //create gas table
		db.createTablesDark(con, tableNameDark); //create dark table
		db.createTablesStar(con, tableNameStar); //create star table
		
		
		//Create prepared statements for bulk insertion
		db.prepareGasStatement(con, tableNameGas);
		db.prepareDarkStatement(con, tableNameDark);
		db.prepareStarStatement(con, tableNameStar);

		buffer = ByteBuffer.allocate(48); //bump it to 4 mb
		
//		insertMeta();
		insertGas(con, buffer, fc, ngas, db);
		insertDark(con, buffer, fc, ndark, db);
		insertStar(con, buffer, fc, nstar, db);
		
		
//		db.createTablesMeta(con, "wtltest_metaJava");
//		db.insertDataDark(con, "wtltest_DarkJava", 2097152, (float)1.07765e-07, (float)-0.477565, (float)-0.446872, 
//				(float)-0.45568, (float)0.100956, (float)0.057776, (float)0.0266779, (float)-0.113261, (float)9.6e-06);
//		db.insertDataGas(con, "wtltest_GasJava", 50, 55, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
//		db.insertDataStar(con, "wtltest_StarJava", 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
//		db.insertDataMeta(con, "wtltest_metaJava", 5, 333, 50, 50, 50, 50);
		db.dbClose(con);
		System.out.println("Connected, but now exiting, goodbye.");
	}

	private static void insertStar(Connection con, ByteBuffer buffer, FileChannel fc, int nstar, DB db) throws IOException {
		long s,t;
		s = System.currentTimeMillis();
		for (int i = 0; i < nstar; i++) {
			if (fc.read(buffer) == -1) {
				System.err.println("Error: unexpected EOF");
				System.exit(1);
			}
			if (i % 9999 == 0) {
				//System.out.println("Now at " + i);
				db.executePreparedStatement(con, STAR_INDEX);
			}
				
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
			db.insertStarPrepared(con, i, mass, x, y, z, vx, vy, vz, phi, metals, tform, eps);	
			buffer.clear();
		}
		db.executePreparedStatement(con, STAR_INDEX);
		db.closePreparedStatement(con, STAR_INDEX);
		t = System.currentTimeMillis();
		System.out.println("Insertion (star) took " + (t-s) + "ms");
	}

	private static void insertDark(Connection con, ByteBuffer buffer, FileChannel fc, int ndark, DB db) throws IOException {
		long s,t;
		s = System.currentTimeMillis();
		for (int i = 0; i < ndark; i++) {
			if (fc.read(buffer) == -1) {
				System.err.println("Error: unexpected EOF");
				System.exit(1);
			}
			if (i % 9999 == 0) {
				//System.out.println("Now at " + i);
				db.executePreparedStatement(con, DARK_INDEX);
			}
				
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
			db.insertDarkPrepared(con, i, mass, x, y, z, vx, vy, vz, phi, eps);	
			buffer.clear();
		}
		db.executePreparedStatement(con, DARK_INDEX);
		db.closePreparedStatement(con, DARK_INDEX);
		t = System.currentTimeMillis();
		System.out.println("Insertion (dark) took " + (t-s) + "ms");
		
	}

	private static void insertGas(Connection con, ByteBuffer buffer, FileChannel fc, int ngas, DB db) throws IOException {
		long s,t;
		s = System.currentTimeMillis();
		for (int i = 0; i < ngas; i++) {
			if (fc.read(buffer) == -1) {
				System.err.println("Error: unexpected EOF");
				System.exit(1);
			}
			if (i % 9999 == 0) {
//				System.out.println("Now at " + i);
				db.executePreparedStatement(con, GAS_INDEX);
			}
				
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
			db.insertGasPrepared(con, i, mass, x, y, z, vx, vy, vz, phi, rho, temp, hsmooth, metals);
			buffer.clear();
		}
		db.executePreparedStatement(con, GAS_INDEX);
		db.closePreparedStatement(con, GAS_INDEX);
		t = System.currentTimeMillis();
		//test(using individual insert) took 2604100ms = 43.40167 minutes
		//test2 (using bulk insert and prepared statements) took 96334 ms = 1.60556667 minutes
		System.out.println("Insertion (gas) took " + (t-s) + "ms");

		
	}

	private static void insertMeta() {
		// TODO Auto-generated method stub
		
	}
}
