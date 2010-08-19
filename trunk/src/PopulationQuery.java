/**
 * 
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements PopulationQuery Program
 * 
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;



public class PopulationQuery {
	// next four constants are relevant to parsing
	public static final int TOKENS_PER_LINE  = 7;
	public static final int POPULATION_INDEX = 4; // zero-based indices
	public static final int LATITUDE_INDEX   = 5;
	public static final int LONGITUDE_INDEX  = 6;

	private static CensusData _data;
	private static Rectangle[][] _xyGrid;
	private static Rectangle _usGrid; 		//Corners of US
	private static int[][] _xyPopGrid;		//Grid with population (for use in ver. 3, 4, 5)
	private static int _versionNumber;		//The version number of program to use
	private static int _x;					//Size of grid (x)
	private static int _y;					//Size of grid (y)
	private static int _totPopulation;		//Total population of US
	private static PQVersionBase program = null;	//Base program for all versions	

	// parse the input file into a large array held in a CensusData object
	public static CensusData parse(String filename) {
		CensusData result = new CensusData();

		try {
			BufferedReader fileIn = new BufferedReader(new FileReader(filename));

			// Skip the first line of the file
			// After that each line has 7 comma-separated numbers (see constants above)
			// We want to skip the first 4, the 5th is the population (an int)
			// and the 6th and 7th are latitude and longitude (floats)
			// If the population is 0, then the line has latitude and longitude of +.,-.
			// which cannot be parsed as floats, so that's a special case
			//   (we could fix this, but noisy data is a fact of life, more fun
			//    to process the real data as provided by the government)

			String oneLine = fileIn.readLine(); // skip the first line

			// read each subsequent line and add relevant data to a big array
			while ((oneLine = fileIn.readLine()) != null) {
				String[] tokens = oneLine.split(",");
				if(tokens.length != TOKENS_PER_LINE)
					throw new NumberFormatException();
				int population = Integer.parseInt(tokens[POPULATION_INDEX]);
				if(population != 0)
					result.add(population,
							Float.parseFloat(tokens[LATITUDE_INDEX]),
							Float.parseFloat(tokens[LONGITUDE_INDEX]));
			}

			fileIn.close();
		} catch(IOException ioe) {
			System.err.println("Error opening/reading/writing input or output file.");
			System.exit(1);
		} catch(NumberFormatException nfe) {
			System.err.println(nfe.toString());
			System.err.println("Error in file format");
			System.exit(1);
		}
		return result;
	}

	// argument 1: file name for input data: pass this to parse
	// argument 2: number of x-dimension buckets
	// argument 3: number of y-dimension buckets
	// argument 4: -v1, -v2, -v3, -v4, or -v5
	public static void main(String[] args) {

		System.out.println("Welcome To Population Query");
		if (args.length != 4 || args[3].length() != 3 || args[3].charAt(0) != '-' ) {
			System.err.println("Usage: java PopulationQuery <filename> <x> <y> [ -v1 | -v2 | -v3 | -v4 | -v5]");
			System.exit(1);
		}
		int[] options = new int[3]; // Storing "translated" options

		//Parse option x and y
		try {
			int x = Integer.parseInt(args[1]);
			options[0] = x;
			int y = Integer.parseInt(args[2]);
			options[1] = y;		
		}
		catch (NumberFormatException e) {
			System.err.println("Usage: java PopulationQuery <filename> <x> <y> [ -v1 | -v2 | -v3 | -v4 | -v5]");
			System.exit(1);
		}

		// Parse version option
		switch (args[3].charAt(2)) {
		case '1':
			options[2] = 1;
			break;
		case '2':
			options[2] = 2;
			break;
		case '3':
			options[2] = 3;
			break;
		case '4':
			options[2] = 4;
			break;
		case '5':
			options[2] = 5;
			break;
		default:
			System.err.println("Usage: java PopulationQuery <filename> <x> <y> [ -v1 | -v2 | -v3 | -v4 | -v5]");
			System.exit(1);
		}
		//for (int i = 0; i < 20; i++)
		preprocess(args[0], options[0], options[1], options[2]);

		//Now for interactive queries
		//Takes in 4 integer query, if not as such, will exit program.
		//The 4 integers are west, east, south and north corners of the grid to query
		boolean notDone = true;
		Scanner console = new Scanner(System.in);
		while(notDone) {
			System.out.print("Please enter your 4 integer query: ");
			String line = console.nextLine().trim();
			String[] tokens = line.split(" ");
			if(tokens.length != 4) {
				System.out.println("Thanks for using this program. Goodbye.");
				notDone = false;
			} else {
				int west = 0;
				int south = 0; 
				int east = 0;
				int north = 0;
				try {
					west = Integer.parseInt(tokens[0]);
					east = Integer.parseInt(tokens[2]);
					south = Integer.parseInt(tokens[1]);
					north = Integer.parseInt(tokens[3]);

					//Check for invalid input w e s n
					if (west < 1 || west > _x || south < 1 || south > _y
							|| east < west || east > _x || north < south || north > _y) {
						System.err.println("You gave the wrong type of numbers in your query! Exiting...");
						System.exit(1);
					}

					//Search based on the query
					Pair<Integer,Float> result = singleInteraction(west, south, east, north);
					System.out.println("Total population within queried area is " + result.getElementA());
					System.out.printf("Percentage of the U.S. population in the queried rectangle: %.2f \n", result.getElementB());
				}
				catch (NumberFormatException e) {
					System.out.println("Thanks for using this program. Goodbye.");
					notDone = false;
				}
			}
		}
	}

	/**
	 * Preprocess the data based on the given x-y grid, the file, and version number
	 * Also for use to support GUI.
	 * 
	 * @param filename the file with the population data
	 * @param x the x coordinate of grid
	 * @param y the y coordinate of grid
	 */
	public static void preprocess(String filename, int x, int y, int versionNum) {
		_data = parse(filename);
		_versionNumber = versionNum;
		_x = x;
		_y = y;
		if (_versionNumber == 1) {
			program = new PQVersionOne(_data);
		} else if (_versionNumber == 2) {
			program = new PQVersionTwo(_data);
		} else if (_versionNumber == 3) {
			program = new PQVersionThree(_data, _x, _y);
		} else if (_versionNumber == 4) {
			program = new PQVersionFour(_data, _x, _y);
		} else { //_versionNumber == 5
			program = new PQVersionFive(_data, _x, _y);
		}

		//For timing
		long s,t;
		for (int i = 0; i < 10; i++) {
			s =  System.currentTimeMillis();
			_usGrid = program.processData();
			t = System.currentTimeMillis();
			System.out.println("Computation (corner finding) took " + (t-s) + "ms");
		}
		_totPopulation = _usGrid.population;
		for (int i = 0; i < 1; i++) {
			oneSec();
			s =  System.currentTimeMillis();
			_xyPopGrid = program.makeGrid(_usGrid);
			t = System.currentTimeMillis();
			System.out.println("Computation (grid making) took " + (t-s) + "ms");
		}
		_xyGrid = program.processPopulationToGrid(_usGrid, x, y);
		//		System.out.println("The total population is (ver.1)" + _totPopulation);
		//		System.out.println("Ver1 USGrid: " + _usGrid);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
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

		long u,t;
		for (int i = 0; i < 1; i++) {
			u =  System.currentTimeMillis();
			if (_versionNumber == 1 || _versionNumber == 2) {
				population = program.processQuery(queryRect);
			} else if (_versionNumber == 3) {
				program = new PQVersionThree(_xyPopGrid);
				population = program.processQuery(n, s, e, w);
			} else if (_versionNumber == 4) {
				program = new PQVersionFour(_xyPopGrid);
				population = program.processQuery(n, s, e, w);
			} else { // _versionNumber == 5
				program = new PQVersionFive(_xyPopGrid);
				population = program.processQuery(n, s, e, w);
			}
			t = System.currentTimeMillis();
			System.out.println("Computation (Query) took " + (t-u) + "ms");
		}
		float percentage = (float) (population * 100.0 / _totPopulation);
		return new Pair(population, percentage);

	}

	//For testing
	public static void oneSec() {
		try {
			Thread.currentThread();
			Thread.sleep(1000);
		}
		catch (InterruptedException e) {
			e.printStackTrace();
		}
	}  
	public static void manySec(long s) {
		try {
			Thread.currentThread();
			Thread.sleep(s * 1000);
		}
		catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}

