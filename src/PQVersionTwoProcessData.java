/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class is part of version two of Population Query
 * using parallel implementation for initial corner finding.
 * 
 */

import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinPool;


@SuppressWarnings("serial")
public class PQVersionTwoProcessData extends RecursiveTask<Rectangle> {


	static final int SEQUENTIAL_THRESHOLD = 5000;
	static final ForkJoinPool fjPool = new ForkJoinPool();


	int low;
	int high;
	CensusData data;

	PQVersionTwoProcessData(CensusData input, int lo, int hi) {
		data = input;
		low = lo;
		high = hi;		
	}
	@Override
	protected Rectangle compute() {
		if(high - low <= SEQUENTIAL_THRESHOLD) {
			Rectangle result = new Rectangle(data.data[0].longitude,data.data[0].longitude,data.data[0].latitude,data.data[0].latitude);
			for(int i=low; i < high; i++) {
				result.population += data.data[i].population;
				float data_latitude = data.data[i].latitude;
				float data_longitude = data.data[i].longitude;
				if(data_longitude < result.left)
					result.left = data_longitude;
				if(data_longitude > result.right)
					result.right = data_longitude;
				if(data_latitude > result.top)
					result.top = data_latitude;
				if(data_latitude < result.bottom)
					result.bottom = data_latitude;

			}
			return result;
		} else {
			int mid = (high + low) / 2;
			PQVersionTwoProcessData left  = new PQVersionTwoProcessData(data, low, mid);
			PQVersionTwoProcessData right = new PQVersionTwoProcessData(data, mid, high);
			left.fork();
			Rectangle rightSide = right.compute();
			Rectangle leftSide = left.join();
			float realLeft = Math.min(rightSide.left, leftSide.left);
			float realRight = Math.max(rightSide.right, leftSide.right);
			float realTop = Math.max(rightSide.top, leftSide.top);
			float realBottom = Math.min(rightSide.bottom, leftSide.bottom);
			return new Rectangle(realLeft, realRight, realTop, realBottom, rightSide.population + leftSide.population);
		}
	}
	
	
	/**
	 * Process the CensusData to get the corners of US
	 * @return the rectangular coordinates of corners of US
	 */
	Rectangle pqversionTwoProcessData() {
		return fjPool.invoke(new PQVersionTwoProcessData(data, 0, data.data_size));
	}
}
