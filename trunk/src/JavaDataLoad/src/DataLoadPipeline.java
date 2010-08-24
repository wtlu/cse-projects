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
		db.createTablesDark(con, "wtltest_DarkJava");
		db.createTablesGas(con, "wtltest_GasJava");
		db.createTablesStar(con, "wtltest_StarJava");
		db.createTablesMeta(con, "wtltest_metaJava");
		db.dbClose(con);
		System.out.println("Connected, but now exiting, goodbye.");
	}
}
