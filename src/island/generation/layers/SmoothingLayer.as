package island.generation.layers
{
import island.generation.GenerationLayer;
import island.tiles.Tile;

public class SmoothingLayer extends GenerationLayer{
	private var _smoothingFactor:int;
	
	public function SmoothingLayer(smoothingFactor:int){
		super();
		_smoothingFactor = smoothingFactor;
	}
	
	override public function apply(tilemap:Vector.<Vector.<int>>, width:int, height:int):Vector.<Vector.<int>>{
		for(var x:int = 0; x < width; x++){
			for(var y:int = 0; y < height; y++){
				
				var count:Vector.<Number> = new Vector.<Number>(Tile.NUM_TILES);
				for (var i:int = -1; i < 2; i++) {
					for (var j:int = -1; j < 2; j++) {
						if (x + i == -1 || x + i == width ||  y + j == -1 || y + j == height) {
							count[Tile.WATER]++;
						} else {
							count[tilemap[x + i][y + j]]++;
						}
					}
				}
				
				var mostCommon:int = -1;
				for(var k:int = 0; k<Tile.NUM_TILES; k++){
					if(count[k] > _smoothingFactor){
						if(mostCommon == -1){
							mostCommon = k;
						}else if(count[k] > count[mostCommon]){
							mostCommon = k;
						}
					}
				}
				
				if(mostCommon != -1){
					tilemap[x][y] = mostCommon;
				}
			}
		}
		return tilemap;
	}	
}
}