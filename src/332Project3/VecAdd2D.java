/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version four of Population Query
 * using parallel implementation for adding two arrays together
 * 
 */

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;


@SuppressWarnings("serial")
public class VecAdd2D extends RecursiveAction {
	int lo, hi;
	int[][] res, arr1, arr2;
	
	static final int SEQUENTIAL_THRESHOLD = 5;
	static final ForkJoinPool fjPool = new ForkJoinPool();
	
	VecAdd2D(int l, int h, int[][] r, int[][] a1, int[][] a2) {
		lo = l;
		hi = h;
		res = r;
		arr1 = a1;
		arr2 = a2;
	}
	@Override
	protected void compute() {
		if (hi - lo < SEQUENTIAL_THRESHOLD) {
			for(int i = lo; i < hi; i++) {
				for(int j = 0; j < res[i].length; j++) {
					res[i][j] = arr1[i][j] + arr2[i][j];
				}
			}
		} else {
			int mid = (hi + lo) / 2;
			VecAdd2D left = new VecAdd2D(lo, mid, res, arr1, arr2);
			VecAdd2D right = new VecAdd2D(mid, hi, res, arr1, arr2);
			left.fork();
			right.compute();
			left.join();
		}

	}
	
	/**
	 * Adds the two array together into a new array
	 * @param arr1 the first array
	 * @param arr2 the second array
	 * @return array with the sum of elements of arr1 and arr2
	 */
	int[][] add(int[][] arr1, int[][] arr2) {
		assert(arr1.length == arr2.length && arr1[0].length == arr2[0].length);
		int[][] ans = new int[arr1.length][arr1[0].length];
		fjPool.invoke(new VecAdd2D(0, arr1.length, ans, arr1, arr2));
		return ans;
	}

}
