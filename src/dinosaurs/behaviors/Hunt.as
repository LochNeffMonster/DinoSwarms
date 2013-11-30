package dinosaurs.behaviors
{
    import flash.geom.Point;
    
    import dinosaurs.Dinosaur;
    import dinosaurs.Gallimimus;
    import dinosaurs.TRex;
    import dinosaurs.Engines.AStar;
    
    import island.TileMap;
    import island.tiles.Tile;
    
    public class Hunt extends Behavior
    {
        private var _gallimimusPoint:Point;
        
        public function Hunt(dino:Dinosaur)
        {
            super(dino);
        }
        
        public function huntForGallimimus():void {
            var dx:Number;
            var dy:Number;
            var distance:Number;
            
            // if the dino has a target tile to get to
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
                // If the dino is at their target, then set null to clear for next food search
                if(currentTile == targetTile) _dinosaur.targetPoint = null;
            }
            
            // if the dino doesn't currently have a target
            if(!_dinosaur.targetPoint){
                // while the dino doesn't have a path, or that they are at their target already
                var tg:Gallimimus = (_dinosaur as TRex).TargetGallimimus;
                if(!_dinosaur.currentPath){
                    _gallimimusPoint = new Point(tg.x,tg.y);
                    _dinosaur.currentPath = AStar.CurrentAStar.GeneratePath(_dinosaur.x,_dinosaur.y,tg.x,tg.y,_dinosaur);
                }else if(_gallimimusPoint.x != tg.x || _gallimimusPoint.y != tg.y){
                    _gallimimusPoint.x = tg.x;
                    _gallimimusPoint.y = tg.y;
                    var tempPath:Array;
                    if(_dinosaur.currentPath.length > 0){
                        tempPath = AStar.CurrentAStar.GeneratePath(_dinosaur.currentPath[_dinosaur.currentPath.length-1].x,_dinosaur.currentPath[_dinosaur.currentPath.length-1].y
                            ,tg.x,tg.y,_dinosaur);
                    }else{
                        tempPath = AStar.CurrentAStar.GeneratePath(_dinosaur.x,_dinosaur.y,tg.x,tg.y,_dinosaur);
                    }
                    if(tempPath){
                        while(tempPath.length != 0){
                            _dinosaur.currentPath.push(tempPath.shift());
                        }
                    }
                }else if(_dinosaur.currentPath.length == 0){
                    dx = Math.abs(tg.x - _dinosaur.x);
                    dy = Math.abs(tg.y - _dinosaur.y);
                    distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
                    if(distance <= _dinosaur.Speed){
                        _dinosaur.x = tg.x;
                        _dinosaur.y = tg.y;
                    }
                }
                // make sure not to overshoot the goalTile
                for(var j:int=0;j<_dinosaur.Speed-1;++j){
                    if(_dinosaur.currentPath.length == 1){
                        break;
                    }
                    _dinosaur.currentPath.pop();
                }
                _dinosaur.targetPoint = _dinosaur.currentPath.pop();
            }else{
                trace("HEY IM BEING CALLED YOU FUCKING ASSHOLE");
                dx = (_dinosaur.targetPoint.x - _dinosaur.x);
                dy = (_dinosaur.targetPoint.y - _dinosaur.y);
                distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
                _dinosaur.x += (dx/distance)*_dinosaur.Speed;
                _dinosaur.y += (dy/distance)*_dinosaur.Speed;
            }
        }
    }
}