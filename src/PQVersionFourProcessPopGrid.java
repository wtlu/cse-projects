/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version four of Population Query 
 * for making a grid of all population
 * 
 */


import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;


@SuppressWarnings("serial")
public class PQVersionFourProcessPopGrid extends RecursiveTask<int[][]> {

	static final int SEQUENTIAL_THRESHOLD = 5000;
	static final ForkJoinPool fjPool = new ForkJoinPool();

	private CensusData data;
	private int low;
	private int high;
	private int[][] arr;
	private MakeGridParameters parameters;
	

	public PQVersionFourProcessPopGrid(int[][] input, CensusData inputData, int lo,
			int hi, MakeGridParameters param) {
		data = inputData;
		arr = input;
		low = lo;
		high = hi;
		parameters = param;
	}

	@Override
	protected int[][] compute() {
		if(high - low <= SEQUENTIAL_THRESHOLD) {
			int[][] result = new int[arr.length][arr[0].length];
			for (int i = low; i < high; i++) {
				float data_lat = data.data[i].latitude;
				float data_long = data.data[i].longitude;
				float adjusted_height = (parameters.gridTop - data_lat);
				float adjusted_width = Math.abs(parameters.gridLeft - data_long);
				int adjusted_x = Math.round(adjusted_width / parameters.xIncrement);
				if (adjusted_x > arr.length - 1)
					adjusted_x = adjusted_x -1;
				int adjusted_y = Math.round(adjusted_height / parameters.yIncrement);
				if (adjusted_y > arr[0].length - 1)
					adjusted_y = adjusted_y - 1;
				result[adjusted_x][adjusted_y] += data.data[i].population;
			}
			return result;
		} else {
			int mid = (high + low) / 2;
			PQVersionFourProcessPopGrid left  = new PQVersionFourProcessPopGrid(arr, data, low, mid, parameters);
			PQVersionFourProcessPopGrid right = new PQVersionFourProcessPopGrid(arr, data, mid, high, parameters);
			left.fork();
			int[][] rightSide = right.compute();
			int[][] leftSide = left.join();
			
			int[][] result = new int[rightSide.length][rightSide[0].length];
			
//			VecAdd2D program = new VecAdd2D(0, result.length, result, rightSide, leftSide);
//			result = program.add(rightSide, leftSide);
			
			
			for (int i = 0; i < rightSide.length; i++) {
				for (int j = 0; j < rightSide[i].length; j++) {
					result[i][j] = rightSide[i][j] + leftSide[i][j];
				}
			}
			return result;
		}
	}
	
	
	/**
	 * Process the array
	 * @return array where each element has population of everyone in that 
	 * particular grid area.
	 */
	public int[][] pqversionFourProcessPopGrid() {
		return fjPool.invoke(new PQVersionFourProcessPopGrid(arr, data, 0, data.data_size, parameters));
	}



}
