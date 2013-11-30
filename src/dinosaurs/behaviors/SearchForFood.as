package dinosaurs.behaviors
{    
	import flash.geom.Point;
	
	import dinosaurs.Dinosaur;
	import dinosaurs.Engines.AStar;
	
	import island.TileMap;
	import island.tiles.Grass;
	import island.tiles.Tile;
	
	public class SearchForFood extends Behavior
	{
		public static const ACCEPTABLE_GROWTH:Number = 0.3;
		
		public function SearchForFood(dino:Dinosaur)
		{
			super(dino);
		}
		
		public function search():void {
			//search for grass to eat
			var dx:Number;
			var dy:Number;
			var distance:Number;
			
			// if the dino has a target tile to get to
			if(_dinosaur.targetPoint){
				trace("I have a target point");
				dx = Math.abs(_dinosaur.targetPoint.x - _dinosaur.x);
				dy = Math.abs(_dinosaur.targetPoint.y - _dinosaur.y);
				distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
				if(distance <= _dinosaur.Speed){
					_dinosaur.x = _dinosaur.targetPoint.x;
					_dinosaur.y = _dinosaur.targetPoint.y;
				}
				var targetTile:Tile = TileMap.CurrentMap.getTileFromCoord(_dinosaur.targetPoint.x,_dinosaur.targetPoint.y);
				var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(Math.floor(_dinosaur.x),Math.floor(_dinosaur.y));
				// If the dino is at their target, then set null to clear for next food search
				if(currentTile == targetTile) _dinosaur.targetPoint = null;
			}
			// if the dino doesn't currently have a target
			if(!_dinosaur.targetPoint){
				trace("I don't have a target point or i'm at it already");
				// while the dino doesn't have a path, or that they are at their target already
				while(!_dinosaur.currentPath || _dinosaur.currentPath.length == 0){
					trace("I need a new path to follow");
					var tmpPoint:Point = new Point(0,0);
					//	get the current sector indices
					var sectorX:int = Math.floor(_dinosaur.x/Grass.GROWTH_RES);
					var sectorY:int = Math.floor(_dinosaur.y/Grass.GROWTH_RES);
					var sectorMax:int = TileMap.WIDTH/Grass.GROWTH_RES;
					// if there is still acceptable growth in the sector, choose a point in the sector
					if(Grass.getGrowthPercent(sectorX,sectorY) > ACCEPTABLE_GROWTH){
						// select a grass tile as a target
						trace("going to another point in my sector");
						tmpPoint.x = Math.round( (Math.random()*sectorMax) );
						tmpPoint.y = Math.round( (Math.random()*sectorMax) );
					}else{
					// find another fertile area to go to
						trace("looking for a new sector to go to");
						// search through the sectors, ignoring the edges that are not likely to have grass
						var randSectorX:int = Math.floor(Math.random()*6 + 2); //sectors 2 to 6
						var randSectorY:int = Math.floor(Math.random()*6 + 2); //sectors 2 to 6
						var fertileSectorFound:Boolean = false;
						while(!fertileSectorFound){
							trace("looking for a fertile sector");
							if(Grass.getGrowthPercent(randSectorX,randSectorY) > ACCEPTABLE_GROWTH){
								fertileSectorFound = true;
							}else{
								// look for another random sector
								randSectorX = Math.floor(Math.random()*6 + 2); //sectors 6 to 26
								randSectorY = Math.floor(Math.random()*6 + 2); //sectors 6 to 26
							}
						}
						tmpPoint.x = randSectorX + Math.random()*sectorMax;
						tmpPoint.x = randSectorY + Math.random()*sectorMax;
					}
					trace("I now have a target point");
					//var rand:Number = Math.random();
					/*_dinosaur.targetPoint = new Point();
					_dinosaur.targetPoint.x = (TileMap.WIDTH - 1)*Math.random()*TileMap.TILE_SIZE;
					_dinosaur.targetPoint.y = (TileMap.HEIGHT - 1)*Math.random()*TileMap.TILE_SIZE;*/
					//var tmpPoint:Point = new Point(0,0);
					//tmpPoint.x = (TileMap.WIDTH - 1)*Math.random()*TileMap.TILE_SIZE;
					//tmpPoint.y = (TileMap.HEIGHT - 1)*Math.random()*TileMap.TILE_SIZE;
					trace(TileMap.CurrentMap.getTileFromCoord(Math.floor(_dinosaur.x),Math.floor(_dinosaur.y)));
					_dinosaur.currentPath = AStar.CurrentAStar.GeneratePath(_dinosaur.x,_dinosaur.y,tmpPoint.x,tmpPoint.y,_dinosaur);
					trace("bacon");
				}
				_dinosaur.targetPoint = _dinosaur.currentPath.pop();
				trace(_dinosaur.targetPoint);
			}else{
				trace(_dinosaur.targetPoint);
				dx = (_dinosaur.targetPoint.x - _dinosaur.x);
				dy = (_dinosaur.targetPoint.y - _dinosaur.y);
				distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
				_dinosaur.x += (dx/distance)*_dinosaur.Speed;
				_dinosaur.y += (dy/distance)*_dinosaur.Speed;
			}
		}
	}
}

