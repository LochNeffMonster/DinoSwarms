package dinosaurs
{
	import flash.events.Event;
	
	import FiniteStateMachine.State;
	import FiniteStateMachine.StateMachine;
	import FiniteStateMachine.Transition;
	
	import dinosaurs.behaviors.Eat;
	import dinosaurs.behaviors.SearchForFood;
	
	import island.TileMap;
	import island.tiles.Grass;
	import island.tiles.Tile;
	
	public class Gallimimus extends Dinosaur
	{        
		public static const BIRF_PERIOD:int = 500; //amount of time it takes for a galimimus to birf
		public function Gallimimus(startX,startY)
		{
			super();
			_speed = 1;
			_dirtCost = 1;
			_grassCost = 2;
			_sandCost = 3;
            _eatRate = Math.random()*.15;
			_birfTimer = BIRF_PERIOD;
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,TileMap.TILE_SIZE*5,TileMap.TILE_SIZE*5);
			graphics.endFill();
            _dinoDistance = 12;
			_carnivore = false;
			_stateMachine = new StateMachine();
			DinoSwarms.galHolder.push(this);
			TileMap.CurrentMap.addChild(this);
			x = startX;
			y = startY;
			//Search
			var search:State = new State("search");
			//search.entryAction = _stateMachine.currentStateName();
			var eat:State = new State("eat");
			//eat.entryAction = _stateMachine.currentStateName();
			search.action = new SearchForFood(this).search;
			_stateMachine.currentState = search;
			
			search.entryAction = function():void { trace("current state is "+_stateMachine.currentStateName); };
			eat.entryAction = function():void { trace("current state is "+_stateMachine.currentStateName); };
			
			var transitionToEat:Transition = new Transition();
			transitionToEat.targetState = eat;
			transitionToEat.condition = function():Boolean {
				if(targetPoint && currentPath.length == 0){
                    targetPoint.x = goalTile.x;
                    targetPoint.y = goalTile.y;
					var dx:Number = Math.abs(targetPoint.x - x);
					var dy:Number = Math.abs(targetPoint.y - y);
					var distance:Number = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
					if(distance <= Speed){
						x = targetPoint.x;
						y = targetPoint.y;
					}
                    
					var targetTile:Tile = TileMap.CurrentMap.getTileFromCoord(targetPoint.x,targetPoint.y);
					var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(x,y);
					if(goalTile != currentTile) return false;
					if(currentTile is Grass && currentPath.length == 0){
						return (currentTile as Grass).IsEdible;
					}else{
						targetPoint = null;
						return false;
					}
				}else{
					return false;
				}
			};
            search.transitions.push(transitionToEat);
			
			//Eat
			eat.action = new Eat(this).eat;
			transitionToEat.targetState = eat;
			var eatTransition:Transition = new Transition();
			eatTransition.targetState = search;
			eatTransition.condition = function():Boolean {		
				var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(x,y);
				if(currentTile is Grass){
					return !(currentTile as Grass).IsEdible;
				}
				
			};
            eat.transitions.push(eatTransition);
			
			var birthTransition:Transition = new Transition();
			birthTransition.targetState = search;
			birthTransition.condition = function():Boolean {		
				var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(x,y);
				if(_birfTimer <= 0 && energy >= 100){
					new Gallimimus(x,y);
					energy = 50;
					_birfTimer = BIRF_PERIOD;
				}
			};
			eat.transitions.push(birthTransition);
			
		}
		
		protected override function onUpdate(e:Event):void{
			var actions:Array = _stateMachine.update();
			for(var a:int in actions){
				actions[a]();
			}
			if(_birfTimer>0){ 
				_birfTimer--;
			}
		}
        
        public function destroy():void {
            //TileMap.CurrentMap.addChild(this);
            trace(this);
            parent.removeChild(this);
			targetPointSprite.parent.removeChild(targetPointSprite);
            for(var i:int in DinoSwarms.galHolder){
                if(DinoSwarms.galHolder[i] == this){
                    DinoSwarms.galHolder.splice(i,1);
                }
            }
        }
	}
}