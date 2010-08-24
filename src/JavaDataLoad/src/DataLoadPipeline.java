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
		db.createTables(con);
		System.out.println("Connected, but now exiting, goodbye.");
	}
}
