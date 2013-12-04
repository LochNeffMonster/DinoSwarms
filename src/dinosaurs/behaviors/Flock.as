package dinosaurs.behaviors
{
    import flash.geom.Point;
    
    import dinosaurs.Dinosaur;
    import dinosaurs.Engines.AStar;
    import dinosaurs.Engines.VectorEngine;
    
    import events.TileEvent;
    
    import island.TileMap;
    import island.tiles.Tile;
    
    public class Flock extends Behavior
    {
		private var _dino:Dinosaur;
		private var tick:int = 180;
		private var range:Number = 4;
		
        public function Flock(dino:Dinosaur)
        {
			
            super(dino);
			_dino = dino;
		}
        
        public function FlockwLeader():void {
			var dx:Number;
			var dy:Number;
			var distance:Number;
            tick += 1;
			
			if (tick >= 180 && _dino.Leader.currentPath && _dino.Leader.currentPath.length > 0)
			{
//				var tmp:Vector.<Point> = VectorEngine.CurrentVectorEngine.ScatterTurkeys(new Point(_dino.x, _dino.y), range);
//				if (tmp[0] != tmp[1]) {
//					var tmpPath:Array = AStar.CurrentAStar.GeneratePath(_dino.x,_dino.y,tmp[1].x, tmp[1].y, _dino);
//					if (tmpPath && tmpPath.length != 0){
//						_dino.currentPath = AStar.CurrentAStar.GeneratePath(
//							tmp[1].x,tmp[1].y,_dino.Leader.x,_dino.Leader.y,_dino);
//						_dino.currentPath = tmpPath.concat(_dino.currentPath);
//						_dino.targetPoint = _dino.currentPath.pop();
//					}
//				}
//				else
//				{
					_dino.currentPath = AStar.CurrentAStar.GeneratePath(
						_dino.x,_dino.y,_dino.Leader.x,_dino.Leader.y,_dino);
				//}
				if (_dino.currentPath && _dino.currentPath.length > 0)
					_dino.goalTile = TileMap.CurrentMap.getTile(_dino.currentPath[0].x, _dino.currentPath[0].y);
				else
					return;
				tick = 0;
			}
			
			if(_dino.targetPoint){
				dx = (_dino.targetPoint.x - _dino.x);
				dy = (_dino.targetPoint.y - _dino.y);
				distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
				if(distance <= _dino.Speed){
					_dino.x = _dino.targetPoint.x;
					_dino.y = _dino.targetPoint.y;
				}
				else
				{
					_dino.x += (dx/distance)*_dino.Speed;
					_dino.y += (dy/distance)*_dino.Speed;
				}
				var targetTile:Tile = TileMap.CurrentMap.getTileFromCoord(_dino.targetPoint.x,_dino.targetPoint.y);
				var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(Math.floor(_dino.x),Math.floor(_dino.y));
				// If the dino is at their target, then set null to clear for next food search
				if(currentTile == targetTile) _dino.targetPoint = null;
			}
			
			if(!_dinosaur.targetPoint){
				//make sure to overshoot the goalTile
				for(var j:int=0;j<_dinosaur.Speed-1;++j){
					if(_dinosaur.currentPath.length == 1){
						break;
					}
					_dinosaur.currentPath.pop();
				}
				_dinosaur.targetPoint = _dinosaur.currentPath.pop();
			}
        }
    }
}