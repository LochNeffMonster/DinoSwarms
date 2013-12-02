package dinosaurs.behaviors
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import dinosaurs.Dinosaur;
    import dinosaurs.TRex;
    import dinosaurs.Engines.AStar;
    
    import island.TileMap;
    import island.tiles.Grass;
    import island.tiles.Tile;
    
    public class SearchForGallimimus extends Behavior
    {
        private static const ACCEPTABLE_GROWTH:Number = 0.3;
        
        private var targetPointSprite:Sprite;
        
        public function SearchForGallimimus(dino:Dinosaur)
        {
            super(dino);
        }
        
        public function search():void {
            var dx:Number;
            var dy:Number;
            var distance:Number;
            
            if(!_dinosaur.shuffledGrass){
                _dinosaur.shuffledGrass = Grass.shuffleGrass();
            }
            
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
                while(!_dinosaur.currentPath || _dinosaur.currentPath.length == 0){
                    var tmpPoint:Point = getNewPointInSector();
                    _dinosaur.currentPath = AStar.CurrentAStar.GeneratePath(_dinosaur.x,_dinosaur.y,tmpPoint.x,tmpPoint.y,_dinosaur);
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
        
        
        private function getNewPointInSector():Point {
			trace("GET NEW POINT BECAUSE PATH IS FINISHED");
            var fallbackGrass:Grass;
            var minGrass:Grass;
			var grass:Array = getAdjacentSectorsOfGrass();
            for(var i:int in grass){
                var g:Grass = grass[i];
				var key:int = getSectorId(g);
				if((_dinosaur as TRex).checkedSectors[key]){
						continue;
				}
				
                var distanceToGrass:int = Math.sqrt((Math.pow(g.x - _dinosaur.x,2) + Math.pow(g.y - _dinosaur.y,2)));
                if(g.IsEdible && !fallbackGrass){
                    fallbackGrass = g;
                }
                if(distanceToGrass < _dinosaur.DinoVisionDistance && g.IsEdible){
                    fallbackGrass = g;
                    //if(Grass.getGrowthPercent(g.x/Grass.GROWTH_RES,g.y/Grass.GROWTH_RES) > ACCEPTABLE_GROWTH){
                        var distanceToCurrentMinGrass:int = (minGrass) ? Math.sqrt((Math.pow(g.x - _dinosaur.x,2) + Math.pow(g.y - _dinosaur.y,2))) : _dinosaur.DinoVisionDistance*2;
                        if(distanceToGrass < distanceToCurrentMinGrass){
                            minGrass = g;
							(_dinosaur as TRex).checkedSectors[key] = true;
                            break;
                        }
                    //}
                }
            }
			if(!fallbackGrass){
				(_dinosaur as TRex).checkedSectors = new Dictionary();
				return getNewPointInSector();
			}
            if(!minGrass){
                minGrass = fallbackGrass;
            }
            if(targetPointSprite){
                TileMap.CurrentMap.removeChild(targetPointSprite);
            }
            targetPointSprite = new Sprite();
            targetPointSprite.graphics.beginFill(0x000000);
            targetPointSprite.graphics.drawRect(0,0,3,3);
            targetPointSprite.graphics.endFill();
            targetPointSprite.x = minGrass.x;
            targetPointSprite.y = minGrass.y;
            TileMap.CurrentMap.addChild(targetPointSprite);
            _dinosaur.goalTile = minGrass;
            return new Point(minGrass.x,minGrass.y);
        }
		
		private function getSectorId(g:Grass):int {
			var numOfSectors:int = TileMap.WIDTH/Grass.GROWTH_RES;
			return numOfSectors*(int(g.y/Grass.GROWTH_RES)) + int(g.x/Grass.GROWTH_RES);
		}
		
		private function getAdjacentSectorsOfGrass():Array {
			var grass:Array = [];
			for(var i:int = Math.floor(_dinosaur.x/Grass.GROWTH_RES) - 1; i < Math.floor(_dinosaur.x/Grass.GROWTH_RES) + 3; ++i){
				if(i < 0) continue;
				if(i >= _dinosaur.shuffledGrass.length) break;
				for(var j:int = Math.floor(_dinosaur.y/Grass.GROWTH_RES) - 1; j < Math.floor(_dinosaur.y/Grass.GROWTH_RES) + 3; ++j){
					if(j < 0) continue;
					if(j >= _dinosaur.shuffledGrass[i].length) break;
					grass = grass.concat(_dinosaur.shuffledGrass[i][j]);
				}
			}
			
			//var returned:Array = ;
			//for(var k:int = 0; k
			
			if(grass.length == 0){
				trace("WTF");
			}
			
			return grass;
		}
    }
}