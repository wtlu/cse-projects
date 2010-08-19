
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version three of Population Query
 * using sequential implementation for initial corner finding 
 * making a grid of all population
 * 
 */

public class PQVersionThree extends PQVersionOne implements PQVersionBase{
	
	private static CensusData data;	//The given Census Data
	private int[][] xyPopGrid;		//The population grid
	private int _x;					//The x coordinate of grid
	private int _y;					//The y coordinate of grid
	
	PQVersionThree(CensusData input, int x, int y) {
		super(input);
		data = input;
		_x = x;
		_y = y;
		xyPopGrid = new int[x][y];
	}
	
	PQVersionThree(int[][] xyPopGrid_input) {
		xyPopGrid = xyPopGrid_input;
	}
	
	/** {@inheritDoc} */
	public int[][] makeGrid(Rectangle USGrid) {
		int[][] result = makePopGrid(USGrid);
		result = makeModifiedPopGrid(result);
		xyPopGrid = result;
		return result;
	}
	
	
	/**
	 * Makes a 2D array with each element contains the population 
	 * located at that given grid in the US
	 * 
	 * @param USGrid the grid and corners of US
	 * @return a 2D array with population in each grid
	 */
	public int[][] makePopGrid(Rectangle USGrid) {
		int[][] result = new int[_x][_y];
		
		float xIncrements = (Math.abs(USGrid.left - USGrid.right))/ _x;
		float yIncrements = (USGrid.top - USGrid.bottom) / _y;
		for (int i = 0; i < data.data_size; i++) {
			float data_lat = data.data[i].latitude;
			float data_long = data.data[i].longitude;
			float adjusted_height = (USGrid.top - data_lat);
			float adjusted_width = Math.abs(USGrid.left - data_long);
			int adjusted_x = Math.round(adjusted_width / xIncrements);
			if (adjusted_x > _x - 1)
				adjusted_x = adjusted_x -1;
			int adjusted_y = Math.round(adjusted_height / yIncrements);
			if (adjusted_y > _y - 1)
				adjusted_y = adjusted_y - 1;
			result[adjusted_x][adjusted_y] += data.data[i].population;
		}
		return result;
	}
	
	/**
	 * 
	 * This method will modify the given input 2D array so that
	 * each element holds the total for that position and all positions that 
	 * are neither further East nor further South.
	 * 
	 * @param input the given population grid
	 * @return a 2D array where each element holds 
	 * the total for that position and all positions 
	 * that are neither further East nor further South.
	 */
	public int[][] makeModifiedPopGrid(int[][] input) {
		if (input.length == 0)
			throw new IllegalArgumentException();
		int[][] result = new int[input.length][input[0].length];
		for (int i = 0; i < input.length; i++) {
			for(int j = 0; j < input[i].length; j++) {
				//Check for left most column, update it
				if (i == 0) {
					if (j == 0)
						result[i][j] = input[i][j];
					else //(j != 0)
						result[i][j] = input[i][j] + result[i][j -1];
				}
				else if(j == 0) //check for top row
					result[i][j] = input[i][j] + result[i-1][j];
				else //do the rest of the columns
					result[i][j] = input [i][j] + result[i][j-1] + result[i-1][j] - result[i-1][j-1];
			}
		}
		return result;
	}
	
	/** {@inheritDoc} */
	public int processQuery(int n, int s, int e, int w) {
		int result = 0;
		int a = xyPopGrid[e][s];
		int b = 0;

		boolean changeB = (n-1) > 0 && (n-1) < xyPopGrid[0].length;
		if (changeB)
			b = xyPopGrid[e][n-1];
		int c = 0;
		boolean changeC = (w-1) > 0 && (w-1) < xyPopGrid.length;
		if (changeC)
			c = xyPopGrid[w-1][s];
		int d = 0;
		if (changeB && changeC)
			d = xyPopGrid[w-1][n-1];
		result = a - b - c + d;
		return result;
	}
	
}
