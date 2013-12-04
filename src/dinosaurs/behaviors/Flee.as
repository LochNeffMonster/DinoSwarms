package dinosaurs.behaviors
{
    import flash.geom.Point;
    
    import dinosaurs.Dinosaur;
    import dinosaurs.TRex;
    import dinosaurs.Engines.AStar;
    import dinosaurs.Engines.VectorEngine;
    
    import events.TileEvent;
    
    import island.TileMap;
    import island.tiles.Tile;
    
    public class Flee extends Behavior
    {
		private var _dino:Dinosaur;
		private var tick:int = 120;
		private var range:Number = 4;
		
        public function Flee(dino:Dinosaur)
        {
			
            super(dino);
			_dino = dino;
		}
        
        public function FleeAway():void {
			var dx:Number;
			var dy:Number;
			var distance:Number;
            tick += 1;
			
			if (tick >= 120)
			{
				var tmp:Vector.<Point> = VectorEngine.CurrentVectorEngine.FleeTurkeys(new Point(_dino.x, _dino.y), 20);
				if (tmp[0] != tmp[1]) {
					_dino.currentPath = AStar.CurrentAStar.GeneratePath(_dino.x,_dino.y,tmp[1].x, tmp[1].y, _dino);
				}
				else
				{
					for each (var t:TRex in DinoSwarms.trexHolder)
					{
						var tx:Number = t.x - _dino.x;
						var ty:Number = t.y - _dino.y;
						if(Math.sqrt(Math.pow(t.x, 2) + Math.pow(t.y, 2)) <= 20 && DinoSwarms.trexHolder.length > 1)
						{
							_dino.currentPath = AStar.CurrentAStar.GeneratePath(
								_dino.x,_dino.y,t.x,t.y,_dino);
							break;

						}
					}
					
				}
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
			
			if(!_dinosaur.targetPoint && _dinosaur.currentPath){
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