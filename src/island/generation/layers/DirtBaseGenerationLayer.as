package island.generation.layers
{
import island.generation.GenerationLayer;

public class DirtBaseGenerationLayer extends GenerationLayer
{
	public function DirtBaseGenerationLayer(){
		super();
	}
	
	/**Creates a square of dirt related to the size of the map.
	 * 
	 * @param Vector.<Vector.<int>> tilemap
	 * @param int width
	 * @param int height
	 * */
	override public function apply(tilemap:Vector.<Vector.<int>>, width:int, height:int):Vector.<Vector.<int>>{
		for(var x:int = 1; x < width-1; x++){
			for(var y:int = 1; y < height-1; y++){
				tilemap[x][y] = 1;
			}
		}
		return tilemap;
	}
}
}