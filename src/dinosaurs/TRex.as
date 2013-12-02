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
    
    public class TRex extends Dinosaur
    {
        private static const GAL_TIMER:int = 120;
        
        private var checkGallimimusTimer:int = 0;
        private var _targetGallimimus:Gallimimus;
        private var _currentCorpse:Corpse;
		
		public var checkedSectors:Dictionary = new Dictionary();
        
        public function TRex()
        {
            currentPath = [];
            super();
            graphics.beginFill(0xFF00FF);
            graphics.drawRect(0,0,TileMap.TILE_SIZE*5,TileMap.TILE_SIZE*5);
            graphics.endFill();
            _speed = 2;
            _dirtCost = 1;
            _grassCost = 2;
            _sandCost = 3;
            _eatRate = Math.random()*.6;
            _dinoDistance = 20;
            _carnivore = true;
            
            _stateMachine = new StateMachine();
            var search:State = new State();
            var hunt:State = new State();
            var eat:State = new State();
            
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
        }
        
        public function get CurrentCorpse():Corpse {
            return _currentCorpse;
        }
        
        public function get TargetGallimimus():Gallimimus {
            return _targetGallimimus;
        }
    }
}