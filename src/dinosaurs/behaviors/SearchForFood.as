package dinosaurs.behaviors
{    
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import dinosaurs.Dinosaur;
	import dinosaurs.Engines.AStar;
	
	import island.TileMap;
	import island.tiles.Grass;
	import island.tiles.Tile;
	
	public class SearchForFood extends Behavior
	{
		private static const ACCEPTABLE_GROWTH:Number = 0.3;
        
        private var targetPointSprite:Sprite;
		
		public function SearchForFood(dino:Dinosaur)
		{
			super(dino);
            if(!_dinosaur.shuffledGrass){
                _dinosaur.shuffledGrass = Grass.shuffleGrass();
            }
		}
		
		public function search():void {
			//search for grass to eat
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
				while(!_dinosaur.currentPath || _dinosaur.currentPath.length == 0){
					var tmpPoint:Point = getNewPointInSector();
					_dinosaur.currentPath = AStar.CurrentAStar.GeneratePath(_dinosaur.x,_dinosaur.y,tmpPoint.x,tmpPoint.y,_dinosaur);
                    if(!_dinosaur.currentPath){
                        for(var i:int in _dinosaur.shuffledGrass){
                            if(_dinosaur.goalTile == _dinosaur.shuffledGrass[i]){
                                _dinosaur.shuffledGrass.splice(i,1);
                                break;
                            }
                        }
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
				dx = (_dinosaur.targetPoint.x - _dinosaur.x);
				dy = (_dinosaur.targetPoint.y - _dinosaur.y);
				distance = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
				_dinosaur.x += (dx/distance)*_dinosaur.Speed;
				_dinosaur.y += (dy/distance)*_dinosaur.Speed;
			}
		}
        
        private function getNewPointInSector():Point {
            
            var fallbackGrass:Grass;
            var minGrass:Grass;
            //We need to get a new array of adjacent grass sectors
            var grassTilesToCheck:Array = getAdjacentSectorsOfGrass();
            var count:int = 0;
            for(var i:int in grassTilesToCheck){
                count++;
                var g:Grass = grassTilesToCheck[i];
                var distanceToGrass:int = Math.sqrt((Math.pow(g.x - _dinosaur.x,2) + Math.pow(g.y - _dinosaur.y,2)));
                if(g.IsEdible && !fallbackGrass){
                    fallbackGrass = g;
                }
                if(isGoalForAnotherDinosaur(g)) continue;
                if(distanceToGrass < _dinosaur.DinoVisionDistance && distanceToGrass > 2 && g.IsEdible){
                    fallbackGrass = g;
                    //if(Grass.getGrowthPercent(g.x/Grass.GROWTH_RES,g.y/Grass.GROWTH_RES) > ACCEPTABLE_GROWTH){
                        var distanceToCurrentMinGrass:int = (minGrass) ? Math.sqrt((Math.pow(g.x - _dinosaur.x,2) + Math.pow(g.y - _dinosaur.y,2))) : _dinosaur.DinoVisionDistance*2;
                        if(distanceToGrass < distanceToCurrentMinGrass){
                            minGrass = g;
                            break;
                        }
                    //}
                }
            }
            trace("CHECKED: " + count);
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
        
        private function isGoalForAnotherDinosaur(g:Tile):Boolean {
            for(var i:int in DinoSwarms.galHolder){
                var d:Dinosaur = DinoSwarms.galHolder[i];
                if(g == d.goalTile) return true;
            }
            return false;
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

