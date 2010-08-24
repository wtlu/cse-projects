import java.sql.*;

public class DataLoadPipeline {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("Welcome to DataLoadPipeline");
		System.out.println("This is just a test");
		DB db = new DB();
		db.dbConnect("fatboy.npl.washington.edu", "NBODY-1", "TheWholeNchilada!");
		System.out.println("Connected, but now exiting, goodbye.");
	}
}
