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
	
	protected var _traversable:Boolean;
	public var x:int, y:int;
	public var tilemap:TileMap;
	
	public function Tile(){
		super();
	}
	
	public function getColor():uint {
		throw new IllegalOperationError();
	}
	
	public function onRemoveFromTilemap():void{
	}
	
	public function onAddToTileMap():void{
	}
	
	public function onUpdate():void {
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
}
}