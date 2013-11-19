package island
{
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import events.TileEvent;

import island.tiles.Tile;
import island.tiles.Water;

public class TileMap extends Sprite
{
	public static const WIDTH:int = 256;
	public static const HEIGHT:int  = 256;
	public static const TILE_SIZE:int = 2;
	
	private static var instCount:int = 0;
	private static var currentMap:TileMap;
	
	private var bitmap:BitmapData = new BitmapData(WIDTH*TILE_SIZE, HEIGHT*TILE_SIZE, false);
	private var tileMap:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>(WIDTH);
	private var updateList:Dictionary = new Dictionary();
	
	/**Constructs a TileMap of size WIDTH and HEIGHT, which
	 * is filled by default with Water.
	 */
	public function TileMap(){
		super();
		
		if(instCount == 0){
			instCount++;
			currentMap = this;
		}else{
			throw("OMFG");
		}
		
		//i = row
		//j = column
		//In order to access tileMap[x][y]
		for(var i:int = 0; i<WIDTH; i++){
			tileMap[i] = new Vector.<Tile>(HEIGHT);
			for(var j:int = 0; j<HEIGHT; j++){
				tileMap[i][j] = new Water();
			}
		}
		
		addEventListener(Event.ADDED_TO_STAGE,init);
	}
	
	/**Initializes the TileMap events 
	 */
	private function init(e:Event):void {
		stage.addEventListener(TileEvent.ON_TILE,onTileEvent,false,0,true);
		stage.addEventListener(TileEvent.EAT_GRASS,eatGrass,false,0,true);
		addEventListener(Event.ENTER_FRAME, onUpdate);
	}
	
	/**Updates any tiles that have a tile event scheduled
	 * for this frame.  This includes updating the image of
	 * the tilemap with the updated tile colors.
	 * 
	 * @param e event
	 */
	private function onUpdate(e:Event):void {
		for(var tile:Tile in updateList){
			updateList[tile]--;
			if(updateList[tile] == 0){
				delete updateList[tile];
				updateTile(tile);
			}
		}
		draw();
	}
	
	/**A Tile can call this method to request that they be given an update
	 * at some time in the future.
	 * 
	 * @param tile to request the update for
	 * @param frameDelay the amount of time in the future to schedule the update
	 */
	public function requestUpdate(tile:Tile, frameDelay:int = 1):void{
		frameDelay = Math.max(1, frameDelay);
		updateList[tile] = updateList[tile] ? Math.min(updateList[tile], frameDelay) : frameDelay;
	}
	
	private function onTileEvent(e:TileEvent):void {
		
	}
	
	private function eatGrass(e:TileEvent):void {
		
	}
	
	/**Calls the update function of a tile, and then updates their colo on the
	 * bitmap
	 * 
	 * @param tile to update
	 */
	private function updateTile(tile:Tile):void{
		tile.onUpdate();
		bitmap.fillRect(new Rectangle(tile.x*TILE_SIZE, tile.y*TILE_SIZE, TILE_SIZE, TILE_SIZE), tile.getColor());
	}
	
	/**Redraws the entire bitmap.  Use only under special circumstances when a 
	 * large number of tiles have changed their color, but have not been updated
	 */
	public function redraw():void{
		for(var x:int = 0; x<WIDTH; x++){
			for(var y:int = 0; y<HEIGHT; y++){
				var tile:Tile = tileMap[x][y];
				bitmap.fillRect(new Rectangle(x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE), tile.getColor());
			}
		}
	}
	
	/**Draws the current bitmap to the TileMap sprite 
	 * this is connected to the ENTER_FRAME event
	 */
	private function draw():void {
		graphics.beginBitmapFill(bitmap);
		graphics.drawRect(0, 0, WIDTH*TILE_SIZE, HEIGHT*TILE_SIZE);
		graphics.endFill();
	}
	
	public static function get CurrentMap():TileMap {
		return currentMap;
	}
	
	/**Returns the 2D vector that hold all of the tiles
	 * 
	 * @return Vector.<Vector.<Tile>> the 2D vector of tiles
	 */
	public function get Map():Vector.<Vector.<Tile>> {
		return tileMap;
	}
	
	/**Returns the Tile located at a specific offset in the tilemap
	 * 
	 * @return Tile the specified tile
	 */
	public function getTile(x:int, y:int):Tile {
		return tileMap[x][y];
	}
	
	/**Returns the Tile located at a specific coordinate in the world
	 * 
	 * @return Tile the specified tile
	 */
	public function getTileFromCoord(x:Number, y:Number):Tile {
		var tileX:int = x/TILE_SIZE;
		var tileY:int = y/TILE_SIZE;
		return tileMap[tileX][tileY];
	}
	
	
	/**Puts a Tile into the tilemap at a specified location.
	 * The added tile has its onAddToTileMap method called
	 * Any tile that was replaced has its onRemoveFromTilemap method called
	 * the added tile has its x, y, and tilemap variables set
	 * 
	 * @param x location to place the tile
	 * @param y location to place the tile
	 * @param tile to add into the tilemap
	 * */
	public function setTile(x:int, y:int, tile:Tile):void {
		if(tileMap[x][y]){
			tileMap[x][y].onRemoveFromTilemap();
			tileMap[x][y].tilemap = null;
			delete updateList[tileMap[x][y]];
			tileMap[x][y] = null;
		}
		
		tileMap[x][y] = tile;
		bitmap.fillRect(new Rectangle(x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE), tile.getColor());
		tile.tilemap = this;
		tile.x = x;
		tile.y = y;
		tile.onAddToTileMap();
	}
}
}