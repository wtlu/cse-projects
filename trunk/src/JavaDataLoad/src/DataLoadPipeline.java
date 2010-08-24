import java.sql.*;

public class DataLoadPipeline {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("Welcome to DataLoadPipeline");
		System.out.println("This is just a test");
		DB db = new DB();
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
