package island.generation
{

import island.TileMap;
import island.tiles.Tile;

public class LevelGeneration{
	public static var STARTING_RESOLUTION:int = 256;
	public static var ENDING_RESOLUTION:int = 1;
	public static var RESOLUTION_STEP:int = 2;
	
	private var layers:Vector.<GenerationLayer> = new Vector.<GenerationLayer>();
	
	private var currentRes:int = STARTING_RESOLUTION;
	private var currentLayer:int = 0;
	private var tileTypes:Vector.<Vector.<int>>; 
	
	public function LevelGeneration(){
		tileTypes = new Vector.<Vector.<int>>(TileMap.WIDTH / STARTING_RESOLUTION);
		for(var i:int = 0; i < TileMap.WIDTH / STARTING_RESOLUTION; i++){
			tileTypes[i] = new Vector.<int>(TileMap.HEIGHT / STARTING_RESOLUTION);
			for(var j:int = 0; j < TileMap.HEIGHT / STARTING_RESOLUTION; j++){
				tileTypes[i][j] = Tile.WATER;
			}
		}
	}
	
	
	/**Starting with a default map filled with water, with the starting resolution.
	 * We step through each layer of the generator, if the layer can be applied at
	 * the current resolution, it is applied, otherwise skipped for this resolution.
	 * 
	 * After all layers are applied, the resolution is halved and the proccess repeates.
	 * The generation terminates once the last pass has been completed at maximum resolution.
	 */
	public function stepGenerate(tileMap:TileMap):void{
		//defining locals
		var i:int, j:int;
		var subI:int, subJ:int;
		
		if(currentRes == 0){
			return;
		}
		
		while(!layers[currentLayer].usesResolution(currentRes)){
			nextLayer();
		}
		
		tileTypes = layers[currentLayer].apply(tileTypes);	
		
		//Convert int array into tileMap	
		for(i = 0; i < TileMap.WIDTH; i++){
			for(j = 0; j < TileMap.HEIGHT; j++){
				subI = i / currentRes;
				subJ = j / currentRes;
				tileMap.setTile(i, j, Tile.createTile(tileTypes[subI][subJ])); //If the TileMap is initialized
			}
		}
		
		nextLayer();
	}
	
	public function finished():Boolean{
		return currentRes == 0;
	}
	
	private function nextLayer():void{
		currentLayer++;
		
		if(currentLayer == layers.length){
			currentLayer = 0;
			currentRes /= RESOLUTION_STEP;
			
			if(currentRes < ENDING_RESOLUTION){
				return;
			}
			
			var newTileTypes : Vector.<Vector.<int>> = new Vector.<Vector.<int>>(TileMap.WIDTH / currentRes);
			for(var i:int = 0; i < TileMap.WIDTH / currentRes; i++){
				newTileTypes[i] = new Vector.<int>(TileMap.HEIGHT / currentRes);
				for(var j:int = 0; j < TileMap.HEIGHT / currentRes; j++){
					var subI:int = i/RESOLUTION_STEP;
					var subJ:int = j/RESOLUTION_STEP;
					newTileTypes[i][j] = tileTypes[subI][subJ];
				}
			}
			
			tileTypes = newTileTypes;
		}
	}
	
	/**Adds a generation layer to the level generation.  During each pass, generation layers
	 * are applied in the same order that they are added to this generator.
	 */
	public function addGenerationLayer(layer:GenerationLayer):void{
		layers.push(layer);
	}
	
	
}

}