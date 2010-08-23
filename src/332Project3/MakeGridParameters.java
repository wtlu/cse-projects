/**
 * Wei-Ting Lu
 * CSE332 Project3
 * This class represents the parameters to making of a grid
 */
public class MakeGridParameters {
	public float xIncrement;	//The amount of x-distance to increase until
								//the next grid
	public float yIncrement;	//The amount of y-distance to increase until
								//the next grid
	public float gridTop;		//Location of the top of the grid (in lat)
	
	public float gridLeft;		//Location of the left of the grid (in long)
	public CensusData data;		//The Census Data
	
	MakeGridParameters(float x, float y, float gt, float gl) {
		xIncrement = x;
		yIncrement = y;
		gridTop = gt;
		gridLeft = gl;
	}
	
}
