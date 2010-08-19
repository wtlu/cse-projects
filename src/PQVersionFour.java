
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version four of Population Query
 * using parallel implementation for initial corner finding 
 * making a grid of all population
 * 
 */
public class PQVersionFour extends PQVersionThree implements PQVersionBase{
	
	private static CensusData data;
	private int _x;
	private int _y;
	
	PQVersionFour(CensusData input, int x, int y) {
		super(input, x, y);
		data = input;
		_x = x;
		_y = y;
	}
	
	public PQVersionFour(int[][] xyPopGrid_input) {
		super(xyPopGrid_input);
	}

	
	/** {@inheritDoc} */
	public Rectangle processData() {
		if (data.data_size == 0)
			return null;

		PQVersionTwoProcessData program = new PQVersionTwoProcessData(data, 0, data.data_size);
		Rectangle result = program.pqversionTwoProcessData();
		
		return result;
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
		PQVersionFourProcessPopGrid program = new PQVersionFourProcessPopGrid(result, data, 0, result.length,parameters);
		result = program.pqversionFourProcessPopGrid();
		return result;
	}
}
