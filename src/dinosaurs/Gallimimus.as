package dinosaurs
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import FiniteStateMachine.State;
	import FiniteStateMachine.StateMachine;
	import FiniteStateMachine.Transition;
	
	import dinosaurs.behaviors.Eat;
	import dinosaurs.behaviors.Flee;
	import dinosaurs.behaviors.Flock;
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

            _eatRate = Math.random()*.015 + .01;

			_birfTimer = BIRF_PERIOD;

			graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,TileMap.TILE_SIZE*2,TileMap.TILE_SIZE*2);
			graphics.endFill();
            _dinoDistance = 12;

			
			//for flocking
			//first number is distance, second is angle range to either side.
			visionRange = new Point(15, 45);
			leader = this;

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
				if(targetPoint && currentPath && currentPath.length == 0){
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
			

			//Flocking
			var flock:State = new State("Flock");
			flock.action = new Flock(this).FlockwLeader;
			var transitionToFlock:Transition = new Transition();
			transitionToFlock.targetState = flock;
			transitionToFlock.condition = Check4Friends;
			var transitionFromFlock:Transition = new Transition();
			transitionFromFlock.targetState = search;
			transitionFromFlock.condition = NoFlock;
			var transitionIfLeader:Transition = new Transition();
			transitionIfLeader.targetState = search;
			transitionIfLeader.condition = IsLeader;
			search.transitions.push(transitionToFlock);
			flock.transitions.push(transitionFromFlock);
			flock.transitions.push(transitionIfLeader);

			//birth
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
			
			//fleeing
			var flee:State = new State("Flee");
			flee.action = new Flee(this).FleeAway;
			var transitionToFlee:Transition = new Transition();
			transitionToFlee.targetState = flee;
			transitionToFlee.condition = RunAway;
			var transitionFromFlee:Transition = new Transition();
			transitionFromFlee.targetState = search;
			transitionFromFlee.condition = StopRunning;
			search.transitions.push(transitionToFlee);
			flock.transitions.push(transitionToFlee);
			eat.transitions.push(transitionToFlee);
			flee.transitions.push(transitionFromFlee);
			
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
			if (targetPointSprite)
				targetPointSprite.parent.removeChild(targetPointSprite);
            for(var i:int in DinoSwarms.galHolder){
                if(DinoSwarms.galHolder[i] == this){
                    DinoSwarms.galHolder.splice(i,1);
                }
            }
        }
		
		public function Check4Friends():Boolean{
			for each (var d:Dinosaur in DinoSwarms.galHolder)
			{
				var hypo:Number = Math.sqrt(Math.pow(d.x - this.x, 2) + Math.pow(d.y - this.y, 2));
				if (hypo <= visionRange.x && hypo > 0 && d.currentPath && d.currentPath.length != 0)
				{
					if (targetPoint != null){
						var hypo2:Number = Math.sqrt(Math.pow(targetPoint.x - this.x, 2) + Math.pow(targetPoint.y - this.y, 2));
						var hypo3:Number = Math.sqrt(Math.pow(d.x - targetPoint.x, 2) + Math.pow(d.y - targetPoint.y, 2));
						var cosA:Number = ((Math.pow(hypo, 2) + Math.pow(hypo2, 2) - Math.pow(hypo3, 2))/ ( 2*hypo*hypo2));
						if (Math.acos(cosA) <= 45)
						{
							//checks to make sure the leader is moving
							if (d.currentPath && d.currentPath.length > 0)
							{
								leader = d.Leader;
								if (leader == this)
									return false;
								graphics.clear();
								graphics.beginFill(0xFFFFFF);
								graphics.drawRect(0,0,TileMap.TILE_SIZE*2,TileMap.TILE_SIZE*2);
								return true;
							}
						}
					}
//					else
//					{
//						leader = d.Leader;
//						return true;
//					}
				}
			}
			return false;
		}
		
		public function NoFlock():Boolean{
			//if leader stops,then stop flocking
			if (!Leader.currentPath || Leader.currentPath.length == 0)
			{
				leader = this;
				if (currentPath)
					currentPath.splice(0);
				graphics.clear();
				graphics.beginFill(0xFF0000);
				graphics.drawRect(0,0,TileMap.TILE_SIZE*2,TileMap.TILE_SIZE*2);
				return true;
			}
			return false;
		}
		
		public function IsLeader():Boolean{
			if (Leader == this)
			{
				if (currentPath)
					currentPath.splice(0);
				graphics.clear();
				graphics.beginFill(0xFF0000);
				graphics.drawRect(0,0,TileMap.TILE_SIZE*2,TileMap.TILE_SIZE*2);
				return true;
			}
			return false;
		}
		
		public function RunAway():Boolean
		{
			for each(var t:TRex in DinoSwarms.trexHolder)
			{
				var tx:Number = t.x - this.x;
				var ty:Number = t.y - this.y;
				if(Math.sqrt(Math.pow(tx, 2) + Math.pow(ty, 2)) <= visionRange.x)
				{
					if (currentPath)
						currentPath.splice(0);
					graphics.clear();
					graphics.beginFill(0xFFFF00);
					graphics.drawRect(0,0,TileMap.TILE_SIZE*2,TileMap.TILE_SIZE*2);
					return true;
				}
			}
			return false;
		}
		
		public function StopRunning():Boolean
		{
			for each(var t:TRex in DinoSwarms.trexHolder)
			{
				var tx:Number = t.x - this.x;
				var ty:Number = t.y - this.y;
				if(Math.sqrt(Math.pow(tx, 2) + Math.pow(ty, 2)) <= visionRange.x)
				{
					return false;
				}
			}
			if (currentPath)
				currentPath.splice(0);
			graphics.clear();
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,TileMap.TILE_SIZE*2,TileMap.TILE_SIZE*2);
			return true;
		}
	}
}