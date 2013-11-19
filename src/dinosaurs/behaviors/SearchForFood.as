package dinosaurs.behaviors
{    
    import flash.geom.Point;
    
    import dinosaurs.Dinosaur;
    
    import island.TileMap;
    import island.tiles.Tile;
    
    public class SearchForFood extends Behavior
    {        
        public function SearchForFood(dino:Dinosaur)
        {
            super(dino);
        }
        
        public function search():void {
            //search for shit to eat
			var dx:Number;
			var dy:Number;
			var distance:Number;
            if(_dinosaur.targetPoint){
				dx = Math.abs(_dinosaur.targetPoint.x - _dinosaur.x);
				dy = Math.abs(_dinosaur.targetPoint.y - _dinosaur.y);
				distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
				if(distance <= _dinosaur.Speed){
					_dinosaur.x = _dinosaur.targetPoint.x;
					_dinosaur.y = _dinosaur.targetPoint.y;
				}
                var targetTile:Tile = TileMap.CurrentMap.getTileFromCoord(_dinosaur.targetPoint.x,_dinosaur.targetPoint.y);
                var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(Math.floor(_dinosaur.x),Math.floor(_dinosaur.y));
				//if(currentTile == targetTile) _dinosaur.targetPoint = null;
            }
            
            if(!_dinosaur.targetPoint){
				var rand:Number = Math.random();
                _dinosaur.targetPoint = new Point();
                _dinosaur.targetPoint.x = (TileMap.WIDTH - 1)*Math.random()*TileMap.TILE_SIZE;
                _dinosaur.targetPoint.y = (TileMap.HEIGHT - 1)*Math.random()*TileMap.TILE_SIZE;
            }else{
                dx = (_dinosaur.targetPoint.x - _dinosaur.x);
                dy = (_dinosaur.targetPoint.y - _dinosaur.y);
                distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
                _dinosaur.x += (dx/distance)*_dinosaur.Speed;
                _dinosaur.y += (dy/distance)*_dinosaur.Speed;
            }
        }
    }
}