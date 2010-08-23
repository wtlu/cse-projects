
/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class implements version two of Population Query
 * using parallel implementation for initial corner finding 
 * and traversal for each query
 * 
 */
public class PQVersionTwo extends PQVersionOne implements PQVersionBase{

	private static CensusData data;

	PQVersionTwo(CensusData input) {
		super(input);
		data = input;
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
	public int processQuery(Rectangle queryRect) {
		if (data.data_size == 0)
			return 0;
		
		PQVersionTwoProcessQuery program = new PQVersionTwoProcessQuery(data, queryRect, 0, data.data_size);
		return program.pqversionTwoProcessData(queryRect);
	}
}
