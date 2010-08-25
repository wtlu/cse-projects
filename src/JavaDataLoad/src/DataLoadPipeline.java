import java.sql.*;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class DataLoadPipeline {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		System.out.println("Welcome to DataLoadPipeline");
		System.out.println("This is just a test");
		DB db = new DB();
		
		if (args.length != 1) {
			System.err.println("Usage: Java DataLoadPipline <tipsyfile>");
			System.exit(1);
		}
		String file = args[0];
		FileInputStream fis = new FileInputStream(file);
		FileChannel fc = fis.getChannel();
		ByteBuffer buffer = ByteBuffer.allocate(48);
		
		if (fc.read(buffer) == -1) {
			System.err.println("Error reading from in-channel");
			System.exit(1);
		}
		// Flip buffer 
		buffer.flip();
		// Following is the specified format, but wrong:
			// what exactly is ntot? I assume that ndim means number of dimensions
			// there are 2097152 lines in particle_gas.csv and 1927510 lines in particle_dark.csv
			// but the header says time=7.2731407807596E-310, ndim=3, ntot=2097152, ngas=2097152, ndark=0, nstar=0.
			// what to do?
		// Get 4 padding bytes
		buffer.getFloat();
		double time = buffer.getDouble();
		int ndim = buffer.getInt();
		int ntot = buffer.getInt();
		int ngas = buffer.getInt();
		int ndark = buffer.getInt();
		int nstar = buffer.getInt();
		System.out.println("time:\t" + time + "\nndim:\t" + ndim +  "\nntot:\t" + ntot + "\nngas:\t" + ngas + "\nndark:\t" + ndark + "\nnstar\t" + nstar);
		
		Connection con = db.dbConnect("jdbc:jtds:sqlserver://fatboy.npl.washington.edu/NBODY", "NBODY-1", "TheWholeNchilada!");
		//db.createTables(con);
//		db.createTablesDark(con, "wtltest_DarkJava");
//		db.createTablesGas(con, "wtltest_GasJava");
//		db.createTablesStar(con, "wtltest_StarJava");
//		db.createTablesMeta(con, "wtltest_metaJava");
		db.insertDataDark(con, "wtltest_DarkJava", 2097152, (float)1.07765e-07, (float)-0.477565, (float)-0.446872, 
				(float)-0.45568, (float)0.100956, (float)0.057776, (float)0.0266779, (float)-0.113261, (float)9.6e-06);
		db.insertDataGas(con, "wtltest_GasJava", 50, 55, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
		db.insertDataStar(con, "wtltest_StarJava", 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
		db.insertDataMeta(con, "wtltest_metaJava", 5, 333, 50, 50, 50, 50);
		db.dbClose(con);
		System.out.println("Connected, but now exiting, goodbye.");
	}
}
