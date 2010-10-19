import java.sql.*;

/**
 * @author Wei-Ting Lu
 *
 * This is a basic class that will allow Database coonection
 * based on jtds and jdbc
 */
public class DB {
	
//	private Connection con; //The connection object
	
	private PreparedStatement insertGas;
	private PreparedStatement insertDark;
	private PreparedStatement insertStar;
//	private PreparedStatement insertMeta;
	private PreparedStatement insertAll;
	private PreparedStatement[] statement = new PreparedStatement[5];
	
	static final int META_INDEX = 0;
	static final int GAS_INDEX = 1;
	static final int DARK_INDEX = 2;
	static final int STAR_INDEX = 3;
	static final int ALL_INDEX = 4;
	
	
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
			conn.setAutoCommit(false);
			
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
    
	//This method will create table that would include all particles
	public void createTableAll(Connection conn, String name) {
        String query;
        Statement stmt;
        
        try
        {
                query="create table " + 
                name +
                " (iOrder int, " +
                "type varchar, " +
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
                "metals float, " +
                "tform float, " +
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
    
    public void executePreparedGas(Connection conn) {
    	try {
			insertGas.executeBatch();
			conn.commit();
			insertGas.clearBatch();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
    }
    
    public void closePreparedGas(Connection conn) {
    	try {
			insertGas.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public void prepareGasStatement(Connection conn, String tableName) {
    	try {
			insertGas = conn.prepareStatement("insert into "+tableName+" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			statement[GAS_INDEX] = insertGas;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public void prepareDarkStatement(Connection conn, String tableName) {
    	try {
			insertDark = conn.prepareStatement("insert into "+tableName+" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			statement[DARK_INDEX] = insertDark;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public void prepareStarStatement(Connection conn, String tableName) {
    	try {
			insertStar = conn.prepareStatement("insert into "+tableName+" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			statement[STAR_INDEX] = insertStar;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    //Create prepared statement for all particle types
    public void prepareAllStatement(Connection conn, String tableName) {
    	try {
			insertAll = conn.prepareStatement("insert into "+tableName+" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			statement[STAR_INDEX] = insertAll;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public void insertGasPrepared(Connection con, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float 
    		phi, float rho, float temp, float hsmooth, float metals) {
    	try {
    		statement[GAS_INDEX].setInt(1, iOrder);
    		statement[GAS_INDEX].setFloat(2, mass);
    		statement[GAS_INDEX].setFloat(3, x);
    		statement[GAS_INDEX].setFloat(4, y);
    		statement[GAS_INDEX].setFloat(5, z);
    		statement[GAS_INDEX].setFloat(6, vx);
    		statement[GAS_INDEX].setFloat(7, vy);
    		statement[GAS_INDEX].setFloat(8, vz);
    		statement[GAS_INDEX].setFloat(9, phi);
    		statement[GAS_INDEX].setFloat(10, rho);
    		statement[GAS_INDEX].setFloat(11, temp);
    		statement[GAS_INDEX].setFloat(12, hsmooth);
    		statement[GAS_INDEX].setFloat(13, metals);
    		statement[GAS_INDEX].addBatch();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    }
    
    public void insertDarkPrepared(Connection con, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float phi, float eps) {
    	try {
    		statement[DARK_INDEX].setInt(1, iOrder);
    		statement[DARK_INDEX].setFloat(2, mass);
    		statement[DARK_INDEX].setFloat(3, x);
    		statement[DARK_INDEX].setFloat(4, y);
    		statement[DARK_INDEX].setFloat(5, z);
    		statement[DARK_INDEX].setFloat(6, vx);
    		statement[DARK_INDEX].setFloat(7, vy);
    		statement[DARK_INDEX].setFloat(8, vz);
    		statement[DARK_INDEX].setFloat(9, phi);
    		statement[DARK_INDEX].setFloat(10, eps);
    		statement[DARK_INDEX].addBatch();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public void insertStarPrepared(Connection con, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float 
    		phi, float metals, float tform, float eps) {
    	try {
    		statement[STAR_INDEX].setInt(1, iOrder);
    		statement[STAR_INDEX].setFloat(2, mass);
    		statement[STAR_INDEX].setFloat(3, x);
    		statement[STAR_INDEX].setFloat(4, y);
    		statement[STAR_INDEX].setFloat(5, z);
    		statement[STAR_INDEX].setFloat(6, vx);
    		statement[STAR_INDEX].setFloat(7, vy);
    		statement[STAR_INDEX].setFloat(8, vz);
    		statement[STAR_INDEX].setFloat(9, phi);
    		statement[STAR_INDEX].setFloat(10, metals);
    		statement[STAR_INDEX].setFloat(11, tform);
    		statement[STAR_INDEX].setFloat(12, eps);
    		statement[STAR_INDEX].addBatch();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public void insertAllPrepared(Connection con, int iOrder, String type, float mass, float x, float y, float z, float vx, float vy, float vz, 
    		float phi, float rho, float temp, float hsmooth, float metals, float tform, float eps) {
    	try {
    		statement[ALL_INDEX].setInt(1, iOrder);
    		statement[ALL_INDEX].setString(2, type);
    		statement[ALL_INDEX].setFloat(3, mass);
    		statement[ALL_INDEX].setFloat(4, x);
    		statement[ALL_INDEX].setFloat(5, y);
    		statement[ALL_INDEX].setFloat(6, z);
    		statement[ALL_INDEX].setFloat(7, vx);
    		statement[ALL_INDEX].setFloat(8, vy);
    		statement[ALL_INDEX].setFloat(9, vz);
    		statement[ALL_INDEX].setFloat(10, phi);
    		statement[ALL_INDEX].setFloat(11, rho);
    		statement[ALL_INDEX].setFloat(12, temp);
    		statement[ALL_INDEX].setFloat(13, hsmooth);
    		statement[ALL_INDEX].setFloat(14, metals);
    		statement[ALL_INDEX].setFloat(15, tform);
    		statement[ALL_INDEX].setFloat(16, eps);
    		statement[ALL_INDEX].addBatch();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    public void executePreparedStatement(Connection conn, int statementSwitch) {
    	try {
			statement[statementSwitch].executeBatch();
			conn.commit();
			statement[statementSwitch].clearBatch();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
    }
    
    public void closePreparedStatement(Connection conn, int statementSwitch) {
    	try {
    		statement[statementSwitch].close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    
    public void insertDataMeta(Connection con, String tableName, int snapId, float time, int total, int dark, int gas, int star) {
    	String input = " values(" + snapId +", " + time +", " 
    	+ total +", " + dark +", " + gas +", " + star + ")";
    	insertData(con, tableName, input);
    }
    
    public void insertDataDark(Connection con, String tableName, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float phi, float eps) {
    	String input = " values(" + iOrder +", " + mass +", " 
    	+ x +", " + y +", " + z +", " + vx +", " + vy +", " + vz +", " +
    			+ phi +", " + eps + ")";
    	insertData(con, tableName, input);
    }
    
    public void insertDataGas(Connection con, String tableName, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float 
    		phi, float rho, float temp, float hsmooth, float metals) {
    	String input = " values(" + iOrder +", " + mass +", " 
    	+ x +", " + y +", " + z +", " + vx +", " + vy +", " + vz +", " +
    			+ phi +", " + rho +", "+ temp +", "+ hsmooth +", "+ metals + ")";
    	insertData(con, tableName, input);
    }
    
    public void insertDataStar(Connection con, String tableName, int iOrder, float mass, float x, float y, float z, float vx, float vy, float vz, float 
    		phi, float metals, float tform, float eps) {
    	String input = " values(" + iOrder +", " + mass +", " 
    	+ x +", " + y +", " + z +", " + vx +", " + vy +", " + vz +", " +
    			+ phi +", " + metals +", "+ tform +", "+ eps + ")";
    	insertData(con, tableName, input);
    }
    
    
}

