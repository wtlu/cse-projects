import java.sql.*;

/**
 * @author Wei-Ting Lu
 *
 * This is a basic class that will allow Database coonection
 * based on jtds and jdbc
 */
public class DB {
	
//	private Connection con; //The connection object
	public DB() {
//		con = null;
	}

	
	/**
	 * This method will connect to the database based on the given
	 * connection string, userid, and password
	 * 
	 * @param db_connect_string the connection URL
	 * @param db_userid the user id of the database
	 * @param db_password the password of database
	 */
	public Connection dbConnect(String db_connect_string, String db_userid, String db_password)
	{
		Connection conn = null;
		try
		{
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection(
					db_connect_string, db_userid, db_password);
//			con = conn;
			System.out.println("connected");
			return conn;

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return conn;
	}
	
	public void dbClose(Connection conn) {
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
    public void createTablesTest(Connection conn)
    {
        String query;
        Statement stmt;
        
        try
        {
                query="create table wtlcust_profile " +
                "(name varchar(32), " +
                "address1 varchar(50), " +
                "city varchar(50), " +
                "state varchar(50), " +
                "country varchar(50))";
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                stmt.close();
//                conn.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void createTablesMeta(Connection conn, String name)
    {
        String query;
        Statement stmt;
        
        try
        {
                query="create table " + 
                name +
                " (snapshot_id int, " +
                "time float, " +
                "total int, " +
                "dark int, " +
                "gas int, " +
                "star int)";
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                stmt.close();
//                conn.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void createTablesDark(Connection conn, String name)
    {
        String query;
        Statement stmt;
        
        try
        {
                query="create table " + 
                name +
                " (iOrder int, " +
                "mass float, " +
                "x float, " +
                "y float, " +
                "z float, " +
                "vx float, " +
                "vy float, " +
                "vz float, " +
                "phi float, " +
                "eps float)";
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                stmt.close();
                //conn.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void createTablesGas(Connection conn, String name)
    {
        String query;
        Statement stmt;
        
        try
        {
                query="create table " +
                name +
                " (iOrder int, " +
                "mass float, " +
                "x float, " +
                "y float, " +
                "z float, " +
                "vx float, " +
                "vy float, " +
                "vz float, " +
                "phi float, " +
                "rho float, " +
                "temp float, " +
                "hsmooth float, " +
                "metals float)";
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                stmt.close();
                //conn.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void createTablesStar(Connection conn, String name)
    {
        String query;
        Statement stmt;
        
        try
        {
                query="create table " +
                name +
                " (iOrder int, " +
                "mass float, " +
                "x float, " +
                "y float, " +
                "z float, " +
                "vx float, " +
                "vy float, " +
                "vz float, " +
                "phi float, " +
                "metals float, " +
                "tform float, " +
                "eps float)";
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                stmt.close();
//                conn.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void insertData(Connection conn, String tableName, String statement)
    {
        Statement stmt;
        try
        {
            stmt = conn.createStatement();
            stmt.executeUpdate("insert into " + tableName + statement);   
            stmt.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void insertDataDark(Connection con, String tableName, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float phi, float eps) {
    	String input = " values(" + iOrder +", " + mass +", " 
    	+ x +", " + y +", " + z +", " + vx +", " + vy +", " + vz +", " +
    			+ phi +", " + eps + ")";
    	insertData(con, tableName, input);
    }
    
}

