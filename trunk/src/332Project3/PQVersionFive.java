
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version five of Population Query
 * using parallel implementation for initial corner finding 
 * making a grid of all population. This implementation also incorporates
 * the use of locks
 * 
 */

public class PQVersionFive extends PQVersionFour implements PQVersionBase{

	static final int NUMBER_THREADS = 4; //The number of threads to use
	
	private static CensusData data;
	private int _x;
	private int _y;
	
	public PQVersionFive(CensusData input, int x, int y) {
		super(input, x, y);
		data = input;
		_x = x;
		_y = y;
	}

	public PQVersionFive(int[][] xyPopGrid_input) {
		super(xyPopGrid_input);
	}
	
	/** {@inheritDoc} */
	public int[][] makeGrid(Rectangle USGrid) {
		int[][] result = makePopGrid(USGrid);
		result = makeModifiedPopGrid(result);
		return result;
	}
	
	/** {@inheritDoc} */
	public int[][] makePopGrid(Rectangle USGrid) {
		int[][] result = new int[_x][_y];
		
		float xIncrements = (Math.abs(USGrid.left - USGrid.right))/ _x;
		float yIncrements = (USGrid.top - USGrid.bottom) / _y;
		MakeGridParameters parameters = new MakeGridParameters(xIncrements, yIncrements, USGrid.top, USGrid.left);
		PQVersionFiveProcessPopGrid program = new PQVersionFiveProcessPopGrid(result, data, null, 0, result.length,parameters);
		try {
			result = program.processPopGrid(result, NUMBER_THREADS);
		} catch (InterruptedException e) {
			System.out.println("There's an error! Interrupted Exception, returning null");
			result = null;
		}
		return result;
	}
}
