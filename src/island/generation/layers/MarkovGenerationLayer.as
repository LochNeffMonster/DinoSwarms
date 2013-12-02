package island.generation.layers
{
import flash.utils.Dictionary;

import island.generation.GenerationLayer;
import island.generation.MarkovModel;
import island.tiles.Tile;


public class MarkovGenerationLayer extends GenerationLayer
{
	private var _MMArray:Dictionary = new Dictionary();
	private var _inPlace:Boolean = false;
	
	public function MarkovGenerationLayer(inPlace:Boolean = false) {
		_inPlace = inPlace;
	}
	
	/**For every tile in the scene, take the quantity of the tile types neiboring to that tile.  These
	 * quantities are input into a markov model, and the resulting probability vector is used to 
	 * determine the new tile type.  If a tile type has no model coupled with it, it remains the same
	 */
	override public function apply(tilemap:Vector.<Vector.<int>>, width:int, height:int):Vector.<Vector.<int>>{
		//create copy of tilemap
		
		var tilemapSource:Vector.<Vector.<int>>;
		if(_inPlace){
			tilemapSource = tilemap;
		}else{
			var x:int, y:int;
			tilemapSource = new Vector.<Vector.<int>>(width);
			for (x = 0; x < width; x++) {
				tilemapSource[x] = new Vector.<int>(height);
				for (y = 0; y < height; y++) {
					tilemapSource[x][y] = tilemap[x][y];
				}
			}
		}
		
		//loop through both tilemaps
		//apply appropriate markov model to each tile using the copy to check neihbors
		////at each tile, getNeibors(tile)
		////doMath()
		////setTile()
		
		for(x = 0; x < width; x++){
			for(y = 0; y < height; y++){
				var model:MarkovModel = _MMArray[tilemapSource[x][y]];
				var neighborArray:Vector.<Number> = getNeighborArray(tilemapSource, x, y, width, height);
				if(model){
					var probability:Vector.<Number> = model.apply(neighborArray);
					var newTile:int = chooseTile(probability);
					if(newTile != -1){
						tilemap[x][y] = newTile;
					}
				}
			}
		}	
		
		return tilemap;
	}
	
	/**Sets the given markov model to be used for the given tile types
	 * If no tile types are given, all tile types are assumed
	 * 
	 * @param model to couple with the tile types
	 * @param tileTypes to couple with the model
	 */
	public function setModel(model:MarkovModel, ... tileTypes):void{
		if(tileTypes.length != 0){
			for each (var type:int in tileTypes){
				_MMArray[type] = model;
			}
		}else{
			for(var i:int = 0; i<Tile.NUM_TILES; i++){
				_MMArray[i] = model;
			}
		}
	}
	
	/**Finds the neighbor array for a given tile in a matrix
	 * 
	 * @param tilemapCopy used for the lookup
	 * @param x coordinate of the tile
	 * @param y coordinate of the tile
	 * @param width of the tilemap
	 * @param height of the tilemap
	 */
	private function getNeighborArray(tilemapCopy, x, y, width, height):Vector.<Number>{
		var count:Vector.<Number> = new Vector.<Number>(Tile.NUM_TILES);
		for (var i:int = -1; i < 2; i++) {
			for (var j:int = -1; j < 2; j++) {
				if (x + i == -1 || x + i == width ||  y + j == -1 || y + j == height) {
					count[Tile.WATER]++;
				} else {
					count[tilemapCopy[x + i][y + j]]++;
				}
			}
		}
		return count;
	}
	
	/**Given a probability vector, return a randomly selected tile type
	 * weighted by the vector.
	 * 
	 * @param probability vector used to choose
	 */
	private function chooseTile(probability:Vector.<Number>):int{
		var tileType:int;
		var rndNum:Number = Math.random();
		var sum:Number = 0;
		var i:int;
		
		for(i = 0; i<probability.length; i++){
			probability[i] = Math.max(probability[i], 0);
			sum += probability[i];
		}
		
		if(sum == 0){
			return -1;
		}
		
		rndNum *= sum;
		
		for (i = 0; i < probability.length; i++) {
			rndNum -= probability[i];
			if (rndNum <= 0)
				return i;
		}
		trace(rndNum);
		throw("got past rng tile choice.");
	}
}

}