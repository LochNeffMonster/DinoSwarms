package dinosaurs
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    
    import FiniteStateMachine.StateMachine;
    
    public class Dinosaur extends Sprite
    {
        public static const MAX_ENERGY:Number = 100;
        
        protected var _carnivore:Boolean;
        protected var _energy:Number;
        protected var _stateMachine:StateMachine;
        protected var _speed:int;
        
        public var targetPoint:Point;
        
        public function Dinosaur()
        {
            super();
            _energy = 70;
            addEventListener(Event.ADDED_TO_STAGE, init);
            //targetPoint = new Point();
        }
        
        private function init(e:Event):void {
            addEventListener(Event.ENTER_FRAME, onUpdate);
        }
        
        protected function onUpdate(e:Event):void {
            
        }
        
        public function get Speed():int {
            return _speed;
        }
    }
}