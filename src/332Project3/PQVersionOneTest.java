
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class is a test for PQVersionOne to 
 * make sure that its methods produce the correct output
 * 
 */
public class PQVersionOneTest {

	static PQVersionOne ver1;
	
	private static Rectangle[][] _xyGrid;
	private static Rectangle _usGrid; 		//Corners of US
	private static int _totPopulation;		//Total population of US
	public static void main(String[] args) {
		CensusData data = new CensusData();
		
		data = setup(data);
		
		ver1 = new PQVersionOne(data);
		_usGrid = ver1.processData();
		_totPopulation = _usGrid.population;
		_xyGrid = ver1.processPopulationToGrid(_usGrid, 2, 2);
		
		//Total Population should be 400
		System.out.println("The total population is (ver.1)" + _totPopulation);
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
		data.add(100, (float)7.5, 25);
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
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Pair<Integer, Float> singleInteraction(int w, int s, int e, int n) {
		w -= 1;
		e -= 1;
		s = (_xyGrid[0].length - 1) - (s - 1);
		n = (_xyGrid[0].length - 1) - (n - 1) ;

		float query_left = _xyGrid[w][n].left;
		float query_right = _xyGrid[e][n].right;
		float query_top = _xyGrid[w][n].top;
		float query_bottom = _xyGrid[e][s].bottom;
		Rectangle queryRect = new Rectangle(query_left, query_right, query_top, query_bottom);
		int population = 0;
		population = ver1.processQuery(queryRect);
		float percentage = (float) (population * 100.0 / _totPopulation);
		return new Pair(population, percentage);

	}
	
	public static void printQuery(int w, int s, int e, int n) {
		Pair<Integer, Float> query = singleInteraction(w,s,e,n);
		System.out.println("Population: " + query.getElementA() + " Percentage: " + query.getElementB());
	}
}
