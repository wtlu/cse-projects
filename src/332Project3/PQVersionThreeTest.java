/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class is a test for PQVersionThree to 
 * make sure that its methods produce the correct output
 * 
 */

import java.util.Arrays;



public class PQVersionThreeTest {
	static PQVersionThree ver3;
	
	private static Rectangle[][] _xyGrid;
	private static Rectangle _usGrid; 		//Corners of US
	private static int[][] _xyPopGrid;		//Grid with population (for use in ver. 3, 4, 5)
	private static int _totPopulation;		//Total population of US
	public static void main(String[] args) {
		CensusData data = new CensusData();
		
		data = setup(data);
		
		ver3 = new PQVersionThree(data, 2, 2);
		_usGrid = ver3.processData();
		_totPopulation = _usGrid.population;
		
		
		//test unmodPopGrid and make sure all element in grid is 100
		int[][] unModResult = ver3.makePopGrid(_usGrid);
		boolean passedTest1 = true;
		for(int i = 0; i < unModResult.length; i++) {
			for (int j = 0; j < unModResult[i].length; j++) {
				int a = unModResult[i][j];
				if (a != 100)
					passedTest1 = false;
			}
		}
		if (passedTest1)
			System.out.println("Passed test for making unmodified pop grid (step 1)");
		else
			System.out.println("Failed test for making unmodified pop grid (step 1)");
		
		
		_xyPopGrid = ver3.makeGrid(_usGrid);
		_xyGrid = ver3.processPopulationToGrid(_usGrid, 2, 2);
		
		//Total Population should be 400
		System.out.println("The total population is (ver.3)" + _totPopulation);
		System.out.println("Ver1 USGrid: " + _usGrid);
		for (int i = 0; i < _xyGrid.length; i++) {
			for (int j = 0; j < _xyGrid[i].length; j++) {
				System.out.println (i + " " + j + " " + _xyGrid[i][j]);
			}
		}
		

		
		printQuery(1,1,1,1); //Bottom left
		printQuery(2,1,2,1); //Bottom right
		printQuery(1,2,1,2); //Top left
		printQuery(2,2,2,2); //Top right
		printQuery(1,1,2,1); //Bottom Row
		printQuery(1,2,2,2); //Top Row
		printQuery(1,1,1,2); //Left Column
		printQuery(2,1,2,2); //Right Column
		printQuery(1,1,2,2); //Total population
		
		
		//test for modified grid making
		int[][] test = {{0, 11, 0, 9},{1, 7, 4, 3},{2, 2, 0, 0,},{9,1,1,1},};
		int[][] expectedResult = {{0,11,11,20}, {1,19,23,35}, {3,23,27,39}, {12,33,38,51},};
		int[][] actualResult = ver3.makeModifiedPopGrid(test);
		System.out.println("The modified array is " + Arrays.deepToString(actualResult));
		boolean passedTest2 = true;
		for(int i = 0; i < test.length; i++) {
			for (int j = 0; j < test[i].length; j++) {
				int a = expectedResult[i][j];
				int b = actualResult[i][j];
				if (a != b)
					passedTest2 = false;
			}
		}
		if (passedTest2)
			System.out.println("Passed test for making modified grid (step 2)");
		else
			System.out.println("Failed test for making modified grid (step2)");
		
	}

	private static CensusData setup(CensusData data) {
		//define the corners to be (lat, long) 
		// (SW): 0,-100 
		//(NW): 10,-100
		// (NE): 10, 100
		//(SE): 0, 100
		data.add(100, 0, -100);
		data.add(100, 0, 100);
		data.add(100, 10, -75);
		data.add(100, (float)8.5, 75);
		return data;
		
	}
	
	/**
	 * Does a single query based on the given west, south, east and north
	 * corners of the query grid
	 * Also used for GUI Support
	 * 
	 * @param w The Western-most column that is part of the rectangle: 
	 * 			Error if this is less than 1 or greater than x.
	 * @param s The Southern-most row that is part of the rectangle: 
	 * 			Error if this is less than 1 or greater than y.
	 * @param e The Eastern-most column that is part of the rectangle: 
	 * 			Error if this is less than the Western-most column 
	 * 			(equal is okay) or greater than x.
	 * @param n The Northern-most row that is part of the rectangle: 
	 * 			Error if this is less than the Southern-most column 
	 * 			(equal is okay) or greater than y.
	 * 
	 * @return the total population in the queried rectangle 
	 * 			and the percentage of the US population in the queried rectangle
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Pair<Integer, Float> singleInteraction(int w, int s, int e, int n) {
		w -= 1;
		e -= 1;
		s = (_xyGrid[0].length - 1) - (s - 1);
		n = (_xyGrid[0].length - 1) - (n - 1) ;

		int population = 0;
		ver3 = new PQVersionThree(_xyPopGrid);
		population = ver3.processQuery(n, s, e, w);
		float percentage = (float) (population * 100.0 / _totPopulation);
		return new Pair(population, percentage);

	}
	
	public static void printQuery(int w, int s, int e, int n) {
		Pair<Integer, Float> query = singleInteraction(w,s,e,n);
		System.out.println("Population: " + query.getElementA() + " Percentage: " + query.getElementB());
	}
}
