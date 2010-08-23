
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version five of Population Query
 * using parallel implementation making a grid of all population. 
 * This implementation also incorporates
 * the use of locks
 * 
 */
public class PQVersionFiveProcessPopGrid extends java.lang.Thread {

	int low;
	int high;
	int[][] arr;
	CensusData data;
	MakeGridParameters parameters;
	int subLen;
	int numThreads;
	Object[][] lockArray;
	
	PQVersionFiveProcessPopGrid(int[][] input, CensusData inputData, Object[][] lockArr, int lo,
			int hi, MakeGridParameters param) {
		data = inputData;
		arr = input;
		lockArray = lockArr;
		low = lo;
		high = hi;
		parameters = param;
	
	}
	
	public void run() {
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
			Object lk = lockArray[adjusted_x][adjusted_y];
			synchronized (lk) {
				arr[adjusted_x][adjusted_y] += data.data[i].population;
			}
		}
	}
	
	/**
	 * 
	 * Parses and adds the population of the US into each of its own grid
	 * in the given array
	 * @param arr the population array that's initially empty
	 * @param numThreads the number of threads to use
	 * @return 2D array with each element contain the population 
	 * located at that particular grid
	 * @throws java.lang.InterruptedException
	 */
	int[][] processPopGrid(int[][] arr, int numThreads) throws java.lang.InterruptedException {
		int subLen = data.data_size / numThreads;
		PQVersionFiveProcessPopGrid[] ts = new PQVersionFiveProcessPopGrid[numThreads];
		
		//now make locks
		Object[][] lockArray = new Object[arr.length][arr[0].length];
		for (int i = 0; i < lockArray.length; i++) {
			for (int j = 0; j < lockArray[i].length; j++) {
				lockArray[i][j] = new Object();
			}
		}
		//Divide the work based on number of threads
		for (int i = 0; i < numThreads -1; i++) {
			ts[i] = new PQVersionFiveProcessPopGrid(arr, data, lockArray, i*subLen, (i+1)*subLen, parameters);
			ts[i].start();
		}
		ts[numThreads -1] = new PQVersionFiveProcessPopGrid(arr, data, lockArray, (numThreads-1)*subLen, data.data_size, parameters);
		ts[numThreads -1].start();
		for (int i = 0; i < numThreads; i++) {
			ts[i].join();
		}
		return arr;
	}
}
