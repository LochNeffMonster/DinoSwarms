package dinosaurs
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import FiniteStateMachine.StateMachine;
	
	import island.tiles.Grass;
	import island.tiles.Sand;
	import island.tiles.Tile;
	
	public class Dinosaur extends Sprite
	{
		public static const MAX_ENERGY:Number = 100;
		
		protected var _carnivore:Boolean;
		protected var _energy:Number;
		protected var _stateMachine:StateMachine;
		protected var _speed:int;
		
		protected var _dirtCost:int;
		protected var _grassCost:int;
		protected var _sandCost:int;
		
		public var targetPoint:Point;
		public var currentPath:Array;
		
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
	}
}