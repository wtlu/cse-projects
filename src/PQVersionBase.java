
/**
 * 
 * Wei-Ting Lu
 * CSE332 Project3
 * This interface describes what all version should have
 * for its methods
 * 
 */
public interface PQVersionBase {
	
	/**
	 * Preprocess the data so that it can return the corners of the US
	 * @return rectangular coordinates of the corners of the US, including its population
	 */
	public Rectangle processData();
	
	
	/**
	 * Makes a population grid for use in version 3, 4 and 5
	 * Each element stores the total population of everyone in the 
	 * rectangle with upper-left corner being the North-West 
	 * corner of the country and the lower-right corner being this position. 
	 * 
	 * @param _usGrid the given corners of the united states
	 * @return a 2D array with each element having the total 
	 * 			population of everyone in the rectangle with upper-left
	 * corner being the NW corner of the country and lower-right corner 
	 * being this position.
	 */
	public int[][] makeGrid(Rectangle _usGrid);
	
	/**
	 * Process the whole US and returns a grid with each element in
	 * the grid represent the rectangular coordinates and area that 
	 * surrounds the grid
	 * @param wholeUS the corners of the US
	 * @param x how many columns in the result rectangle
	 * @param y how many rows in the result rectangle
	 * @return a 2D array of rectangles that is a mapping of north south east west
	 * 			into a rectangular coordinate
	 */
	public Rectangle[][] processPopulationToGrid(Rectangle wholeUS, int x, int y);
	
	/**
	 * Process the query based on the given north, south
	 * east, and west coordinates of the rectangular grid
	 * Note that the notation coordinates are in CS coordinates index and not
	 * cartesian coordinate system.
	 * 
	 * @param n The Northern-most row that is part of the rectangle
	 * @param s The Southern-most row that is part of the rectangle
	 * @param e The Eastern-most column that is part of the rectangle
	 * @param w The Western-most column that is part of the rectangle
	 * @return
	 */
	public int processQuery(int n, int s, int e, int w);
	
	/**
	 * Process the query based on the given rectangle coordinates
	 * @param rect the rectangle with coordinates of the query
	 * @return the population of the given rectangluar query
	 */
	public int processQuery(Rectangle rect);
}
