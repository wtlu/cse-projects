import java.sql.*;

/**
 * @author Wei-Ting Lu
 *
 * This is a basic class that will allow Database coonection
 * based on jtds and jdbc
 */
public class DB {
	
	private Connection con; //The connection object
	public DB() {
		con = null;
	}

	
	/**
	 * This method will connect to the database based on the given
	 * connection string, userid, and password
	 * 
	 * @param db_connect_string the connection URL
	 * @param db_userid the user id of the database
	 * @param db_password the password of database
	 */
	public void dbConnect(String db_connect_string, String db_userid, String db_password)
	{
		try
		{
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			Connection conn = DriverManager.getConnection(
					db_connect_string, db_userid, db_password);
			con = conn;
			System.out.println("connected");

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}

