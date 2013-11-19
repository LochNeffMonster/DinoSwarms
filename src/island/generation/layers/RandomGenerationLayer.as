package island.generation.layers
{
import island.generation.GenerationLayer;
import island.tiles.Tile;

public class RandomGenerationLayer extends GenerationLayer
{
	public function RandomGenerationLayer(){
		super();
	}
	
	override public function apply(tilemap:Vector.<Vector.<int>>):Vector.<Vector.<int>>{
		for(var x:int = 0; x < tilemap.length; x++){
			for(var y:int = 0; y < tilemap[x].length; y++){
				tilemap[x][y] = Math.random() * 5;
			}
		}
		return tilemap;
	}
}
}