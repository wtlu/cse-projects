/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements part of version two of Population Query
 * using parallel implementation traversal for each query
 * 
 */

import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinPool;


@SuppressWarnings("serial")
public class PQVersionTwoProcessQuery extends RecursiveTask<Integer> {

	static final int SEQUENTIAL_THRESHOLD = 5000;
	static final ForkJoinPool fjPool = new ForkJoinPool();

	int low;
	int high;
	CensusData data;
	Rectangle query;

	PQVersionTwoProcessQuery(CensusData input, Rectangle queryRect, int lo, int hi) {
		data = input;
		query = queryRect;
		low = lo;
		high = hi;		
	}
	
	@Override
	protected Integer compute() {
		if(high - low <= SEQUENTIAL_THRESHOLD) {
			Integer result = 0;
			for(int i = low; i < high; i++) {
				float data_lat = data.data[i].latitude;
				float data_long = data.data[i].longitude;
				if (data_lat <= query.top && data_lat >= query.bottom
						&& data_long >= query.left && data_long <= query.right) {
					result += data.data[i].population;
				}
			}
			return result;
		} else {
			int mid = low + (high - low) / 2;
			PQVersionTwoProcessQuery left  = new PQVersionTwoProcessQuery(data, query, low, mid);
			PQVersionTwoProcessQuery right = new PQVersionTwoProcessQuery(data, query, mid, high);
			left.fork();
			Integer rightSide = right.compute();
			Integer leftSide = left.join();

			return rightSide + leftSide;
		}
	}


		/**
		 * Gets the population of the given query rectangle
		 * @param queryInput the query rectangle
		 * @return the population of the given query
		 */
		Integer pqversionTwoProcessData(Rectangle queryInput) {
			return fjPool.invoke(new PQVersionTwoProcessQuery(data, queryInput, 0, data.data_size));
		}
	
}
