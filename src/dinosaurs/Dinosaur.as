package dinosaurs
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import FiniteStateMachine.StateMachine;
	
	import island.TileMap;
	
	import island.tiles.Grass;
	import island.tiles.Sand;
	import island.tiles.Tile;
	
	public class Dinosaur extends Sprite
	{
		public static const MAX_ENERGY:Number = 100;
		
		protected var _carnivore:Boolean;
		protected var _birfTimer:int; 
		protected var _stateMachine:StateMachine;
		protected var _speed:Number;
        protected var _eatRate:Number;
		
		protected var _dirtCost:int;
		protected var _grassCost:int;
		protected var _sandCost:int;
        protected var _dinoDistance:int;
		//used for flocking behaviors
		protected var visionRange:Point;
		protected var leader:Dinosaur;
		
		public var energy:Number; //between 0 and 100
		public var targetPoint:Point;
		public var currentPath:Array;
        public var goalTile:Tile;
        public var shuffledGrass:Array;
		public var targetPointSprite:Sprite;
		
		public function Dinosaur()
		{
			super();
			energy = 70;
			addEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			//targetPoint = new Point();
		}
		
		private function init(e:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
        
        protected function onRemoved(e:Event):void {
            removeEventListener(Event.ENTER_FRAME, onUpdate);
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
        }
		
		protected function onUpdate(e:Event):void {
			
		}
		
		public function get Speed():Number {
			if (targetPoint)
				return _speed / MoveCost(TileMap.CurrentMap.getTile(targetPoint.x, targetPoint.y));
			else
				return _speed;
		}
		
		public function MoveCost(tile:Tile):int
		{
			if(tile is Grass)
			{
				if((tile as Grass).IsEdible)
					return _grassCost;
				else
					return _dirtCost;
			}
			else if (tile is Sand)
			{
				return _sandCost;
			}
			return 2;
		}
        public function get EatRate():Number{
            return _eatRate;
        }
        
        public function get DinoVisionDistance():int {
            return _dinoDistance;
        }
		
		public function get Leader():Dinosaur{
			return leader;
		}

	}
}