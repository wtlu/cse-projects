
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version one of Population Query
 * using sequential and simple processing
 * 
 */
public class PQVersionOne implements PQVersionBase{
	
	protected static CensusData data;
	
	PQVersionOne(CensusData input) {
		data = input;
	}
	
	PQVersionOne() {
		data = null;
	}
	
	/** {@inheritDoc} */
	public int processQuery(Rectangle queryRect) {
		int result = 0;
		for(int i = 0; i < data.data_size; i++) {
			float data_lat = data.data[i].latitude;
			float data_long = data.data[i].longitude;
			if (data_lat <= queryRect.top && data_lat >= queryRect.bottom
					&& data_long >= queryRect.left && data_long <= queryRect.right) {
				result += data.data[i].population;
			}
		}
		return result;
	}
	
	/** {@inheritDoc} */
	public Rectangle[][] processPopulationToGrid(Rectangle wholeUS, int x, int y) {
		Rectangle[][] result = new Rectangle[x][y];
		float xIncrements = Math.abs(wholeUS.left - wholeUS.right)/ x;
		float yIncrements = (wholeUS.top - wholeUS.bottom) / y;
		for (int i = 0; i < x; i++) {
			for (int j = 0; j < y; j++) {
				float left = wholeUS.left + (i*xIncrements);
				float right = wholeUS.left + (i+1)*xIncrements;
				float top = wholeUS.top - (j*yIncrements);
				float bottom = wholeUS.top - (j+1)*yIncrements;
				result[i][j] = new Rectangle(left, right, top, bottom);
			}
		}
		return result;
	}
	
	/** {@inheritDoc} */
	public Rectangle processData() {
		if (data.data_size == 0)
			return null;

		Rectangle result = new Rectangle(data.data[0].longitude,data.data[0].longitude,data.data[0].latitude,data.data[0].latitude, data.data[0].population);
	
		for (int i = 1; i < data.data_size; i++) {
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
	}

	@Override
	/** {@inheritDoc} */
	public int[][] makeGrid(Rectangle _usGrid) {
		// VersionOne doesn't need to make it, so returns null
		return null;
	}

	@Override
	/** {@inheritDoc} */
	public int processQuery(int n, int s, int e, int w) {
		// Version one doesn't do this. Will return 0
		return 0;
	}
}
