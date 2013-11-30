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
		public function Gallimimus()
		{
			super();
			_speed = 1;
			_dirtCost = 1;
			_grassCost = 2;
			_sandCost = 3;
            _eatRate = Math.random()*.015;
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,TileMap.TILE_SIZE*5,TileMap.TILE_SIZE*5);
			graphics.endFill();
            _dinoDistance = 12;
			
			_carnivore = false;
			_stateMachine = new StateMachine();
			//Search
			var search:State = new State();
			var eat:State = new State();
			search.action = new SearchForFood(this).search;
			_stateMachine.currentState = search;
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
			
		}
		
		protected override function onUpdate(e:Event):void{
			var actions:Array = _stateMachine.update();
			for(var a:int in actions){
				actions[a]();
			}
		}
	}
}