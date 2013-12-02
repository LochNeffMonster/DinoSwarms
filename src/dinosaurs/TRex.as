package dinosaurs
{
    import flash.events.Event;
    
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
        
        public function TRex()
        {
            currentPath = [];
            super();
            graphics.beginFill(0xFF00FF);
            graphics.drawRect(0,0,TileMap.TILE_SIZE*5,TileMap.TILE_SIZE*5);
            graphics.endFill();
            _speed = 3;
            _dirtCost = 1;
            _grassCost = 2;
            _sandCost = 3;
            _eatRate = Math.random()*.1;
            _dinoDistance = 20;
            _carnivore = true;
            
            _stateMachine = new StateMachine();
            var search:State = new State("search");
            var hunt:State = new State("hunt");
            var eat:State = new State("eat");
            
            search.action = new SearchForGallimimus(this).search;
            var searchToHuntTransition:ITransition = new Transition();
            searchToHuntTransition.condition = function():Boolean {
                if(currentPath.length == 0 || --checkGallimimusTimer <= 0){
                    currentPath = null;
                    return checkIfGallimimusInRange();
                }
            };
            searchToHuntTransition.targetState = hunt;
            search.transitions.push(searchToHuntTransition);
            
            hunt.action = new Hunt(this).huntForGallimimus;
            var beginToEat:ITransition = new Transition();
            beginToEat.condition = function():Boolean {
                if(_targetGallimimus.x == x && _targetGallimimus.y == y){
                    //_targetGallimimus.parent.removeChild(_targetGallimimus);
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
                    return true;
                }
                return false;
            };
            goBackToSearch.targetState = search;
            eat.transitions.push(goBackToSearch);
            
            _stateMachine.currentState = search;
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
        }
        
        public function get CurrentCorpse():Corpse {
            return _currentCorpse;
        }
        
        public function get TargetGallimimus():Gallimimus {
            return _targetGallimimus;
        }
    }
}