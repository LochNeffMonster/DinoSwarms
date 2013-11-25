package island.tiles
{
import flash.errors.IllegalOperationError;

import island.TileMap;

public class Tile{
	public static var WATER:int = 0;
	public static var DIRT:int = 1;
	public static var GRASS:int = 2;
	public static var SAND:int = 3;
	public static var TREE:int = 4;
	public static var NUM_TILES:int = 5;
	
	protected var _traversable:Boolean;
	public var x:int, y:int;
	public var tilemap:TileMap;
	
	protected var _plannedUpdates:int = 0;
	
	public function Tile(){
		super();
	}
	
	/**Returns the color that this tile should be drawn as
	 * This color is only going to be drawn to the tilemap whenever
	 * the tile experiences a tile update.
	 * 
	 * @return color
	 */
	public function getColor():uint {
		throw new IllegalOperationError();
	}
	
	/**This method is called whenever this tile is removed
	 * from the tilemap.
	 */
	public function onRemoveFromTilemap():void{
	}
	
	/**This method is called whenever this tile is added
	 * to the tilemap.  If the tile needs constant updates, it
	 * should request the first of them during this call
	 */
	public function onAddToTileMap():void{
	}
	
	/**This method is called whenever the tile experiences
	 * an update.  
	 */
	public function onUpdate():void {
		_plannedUpdates--;
	}
	
	protected function requestUpdate(frames:int):void{
		tilemap.requestUpdate(this, frames);
		_plannedUpdates++;
	}
	
	/**
	 * Needed accessor for Pathfinding. Love Kevin
	 */
	public function getTraversable():Boolean
	{
		return _traversable;
	}
	
	/**
	 * Function createTile
	 * This function returns a new tile according to the type of tile passed as parameter.
	 * 
	 * Params: int type
	 * Returns: Tile (any of them) 
	 */
	public static function createTile(type:int):Tile{
		switch (type){
			case Tile.WATER:
				return new Water();
			case Tile.DIRT:
				return new Grass(0, 0);
			case Tile.GRASS:
				return new Grass(1, 0.1);
			case Tile.SAND:
				return new Sand();
			case Tile.TREE:
				return new Tree();
			default:
				throw new IllegalOperationError();
		}	
	}
	
	/**This method returns the color coupled with the given tileType
	 * 
	 * @param type of tile
	 * @returns color
	 */
	public static function getSimpleTileColor(type:int):uint{
		switch (type){
			case Tile.WATER:
				return Water.WATER_COLOR.color;
			case Tile.DIRT:
				return Grass.DIRT_COLOR.color;
			case Tile.GRASS:
				return Grass.GRASS_COLOR.color;
			case Tile.SAND:
				return Sand.SAND_COLOR.color;
			case Tile.TREE:
				return Tree.TREE_COLOR.color;
			default:
				throw new IllegalOperationError();
		}	
	}
}
}