package island.generation
{

public class MarkovModel{
	
	private var _model:Vector.<Vector.<Number>>;
	
	/**MarkovModel
	 * 
	 * Initializes the class with a probability matrix.  Input is a row-col array so that
	 * MarkovMovel can be created like   new MarkovModel([[0, 0, 0], 
	 *                                                    [0, 0, 0]);
	 * 
	 * Usage:
	 *   w d g s t f l b
	 * w
	 * d
	 * g
	 * s
	 * t
	 * f
	 * l
	 * b
	 * 
	 * Column neighbour affects chance of becoming row type.
	 * 
	 * @params: matrix Array
	 * */
	public function MarkovModel(matrix:Array){
		_model = new Vector.<Vector.<Number>>(matrix[0].length);
		for(var x:int = 0; x<_model.length; x++){
			_model[x] = new Vector.<Number>(matrix.length);
			for(var y:int = 0; y<_model[x].length; y++){
				_model[x][y] = matrix[y][x];
			}
		}
	}
	
	
	/**
	 * apply (*)
	 * 
	 * This function multiplies the model matrix with a user vector input.
	 * 
	 * @params: input Vector.<Number>
	 * @return: result Vector.<Number>
	 * 
	 * */
	public function apply(input:Vector.<Number>):Vector.<Number>{
		var result:Vector.<Number> = new Vector.<Number>(input.length);
		var column:int, row:int;

		for (column = 0; column<_model.length; column++){
			for (row = 0; row<_model.length; row++){
				result[column] += _model[row][column] * input[row];
			}
		}
		
		return result;
	}
}

}