package dinosaurs
{
    import flash.events.Event;
    import flash.utils.Dictionary;
    
    import FiniteStateMachine.ITransition;
    import FiniteStateMachine.State;
    import FiniteStateMachine.StateMachine;
    import FiniteStateMachine.Transition;
    
    import dinosaurs.behaviors.EatGallimimus;
    import dinosaurs.behaviors.Hunt;
    import dinosaurs.behaviors.SearchForGallimimus;
    
    import island.TileMap;
    import island.tiles.Tile;
    
    public class TRex extends Dinosaur
    {
        private static const GAL_TIMER:int = 120;
		public static const BIRF_PERIOD:int = 500; //amount of time it takes for a t-rex to birf
        private var checkGallimimusTimer:int = 0;
        private var _targetGallimimus:Gallimimus;
        private var _currentCorpse:Corpse;
		
		public var checkedSectors:Dictionary = new Dictionary();
        
        public function TRex(startX, startY)
        {
            currentPath = [];
            super();
            graphics.beginFill(0xFF00FF);
            graphics.drawRect(0,0,TileMap.TILE_SIZE*5,TileMap.TILE_SIZE*5);
            graphics.endFill();
            _speed = 2;
            _dirtCost = 1;
            _grassCost = 2;
            _sandCost = 5;
            _eatRate = Math.random()*.6;
            _dinoDistance = 20;
            _carnivore = true;
			_birfTimer = BIRF_PERIOD;
			x = startX;
			y = startY;
			
			TileMap.CurrentMap.addChild(this);
			DinoSwarms.trexHolder.push(this);
            
            _stateMachine = new StateMachine();
            var search:State = new State("search");
            var hunt:State = new State("hunt");
            var eat:State = new State("eat");
            
            search.action = new SearchForGallimimus(this).search;
            var searchToHuntTransition:ITransition = new Transition();
            searchToHuntTransition.condition = function():Boolean {
				if(!currentPath){
					checkGallimimusTimer = GAL_TIMER;
					return checkIfGallimimusInRange();
				}else if(currentPath.length == 0 || --checkGallimimusTimer <= 0){
					checkGallimimusTimer = GAL_TIMER;
                    currentPath = null;
                    return checkIfGallimimusInRange();
                }
            };
            searchToHuntTransition.targetState = hunt;
            search.transitions.push(searchToHuntTransition);
            
			var huntToSearchTransition:Transition = new Transition();
			huntToSearchTransition.targetState = search;
			huntToSearchTransition.condition = function():Boolean{
				if(_targetGallimimus == null){
					return true;
				}
				if(_targetGallimimus.parent == null){
					_targetGallimimus = null;
					return true;
				}
			}
			hunt.transitions.push(huntToSearchTransition);
			
            hunt.action = new Hunt(this).huntForGallimimus;
            var beginToEat:ITransition = new Transition();
            beginToEat.condition = function():Boolean {
				var dx:Number = Math.abs(_targetGallimimus.x - x);
				var dy:Number = Math.abs(_targetGallimimus.y - y);
				var distance:Number = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
				if(distance <= Speed){
					x = _targetGallimimus.x;
					y = _targetGallimimus.y;
                    _targetGallimimus.destroy();
                    _targetGallimimus = null;
                    _currentCorpse = new Corpse();
                    _currentCorpse.x = x;
                    _currentCorpse.y = y;
                    TileMap.CurrentMap.addChild(_currentCorpse);
                    return true;
                }
                return false;
            };
            beginToEat.targetState = eat;
            hunt.transitions.push(beginToEat);
            
            eat.action = new EatGallimimus(this).eat;
            var goBackToSearch:ITransition = new Transition();
            goBackToSearch.condition = function():Boolean {
                if(_currentCorpse.percentEaten >= 1){
                    TileMap.CurrentMap.removeChild(_currentCorpse);
                    _currentCorpse = null;
					trace("TRANSITIONING TO SEARCH");
					checkedSectors = new Dictionary();
                    return true;
                }
                return false;
            };
            goBackToSearch.targetState = search;
            eat.transitions.push(goBackToSearch);
            
            _stateMachine.currentState = search;
			
			var birthTransition:Transition = new Transition();
			birthTransition.targetState = search;
			birthTransition.condition = function():Boolean {		
				var currentTile:Tile = TileMap.CurrentMap.getTileFromCoord(x,y);
				if(_birfTimer <= 0 && energy >= 100){
					new TRex(x,y);
					energy = 50;
					_birfTimer = BIRF_PERIOD;
				}
			};
			eat.transitions.push(birthTransition);
			search.entryAction = function():void { trace("current state is "+_stateMachine.currentStateName ); };
			hunt.entryAction = function():void { trace("current state is "+_stateMachine.currentStateName ); };
			eat.entryAction = function():void { trace("current state is "+_stateMachine.currentStateName ); };
			
			
        }
        
        public function checkIfGallimimusInRange():Boolean {
            var minDist:int = _dinoDistance*2;
            for(var i:int in DinoSwarms.galHolder){
                var g:Gallimimus = DinoSwarms.galHolder[i];
                var gDist:Number = Math.sqrt(Math.pow(g.x - x,2) + Math.pow(g.y - y,2));
                if(gDist < minDist){
                    minDist = gDist;
                    _targetGallimimus = g;
                }
            }
            if(_targetGallimimus) trace("SEEN GALLIMIMUS - TRANSITIONING");
            
            return (_targetGallimimus);
        }
        
        protected override function onUpdate(e:Event):void {
            var actions:Array = _stateMachine.update();
            for(var a:int in actions){
                actions[a]();
            }
			if(_birfTimer>0){ 
				_birfTimer--;
			}
			energy-=0.3
			if(energy <= 0){
				this.destroy();
			}
        }
		
		public function destroy():void {
			//TileMap.CurrentMap.addChild(this);
			trace(this);
			parent.removeChild(this);
			if (targetPointSprite)
				targetPointSprite.parent.removeChild(targetPointSprite);
			for(var i:int in DinoSwarms.galHolder){
				if(DinoSwarms.trexHolder[i] == this){
					DinoSwarms.trexHolder.splice(i,1);
				}
			}
		}
        
        public function get CurrentCorpse():Corpse {
            return _currentCorpse;
        }
        
        public function get TargetGallimimus():Gallimimus {
            return _targetGallimimus;
        }
    }
}