package dinosaurs.Engines
{
	import flash.geom.Point;
	
	import island.tiles.Tile;
	
	public class Node
	{
		//coordinates
		protected var _Coordinate:Point;
		protected var _Heuristic:Number; //heuristic cost
		protected var _Connection:Point; //where it came from
		protected var _CostSoFar:Number; //the cost to get here
		protected var _EstimatedCost:Number; //the estimated total cost
		protected var _State:int; //0 unvisited, 1 open, 2 closed
		
		public function Node(Xoor:Number, Yoor:Number, Connection:Point, CostSoFar:Number, Heuristic:Number, State:int)
		{
			_Coordinate = new Point(Xoor,Yoor);
			_Connection = Connection;
			_CostSoFar = CostSoFar;
			_Heuristic = Heuristic;
			_EstimatedCost = _CostSoFar + _Heuristic;
			_State = State;
		}
		
		public function get Coordinate():Point
		{
			return _Coordinate;
		}
		
		public function get CostSoFar():Number
		{
			return _CostSoFar;
		}
		
		public function get EstimatedCost():Number
		{
			return _EstimatedCost;
		}
		
		public function get State():int
		{
			return _State;
		}
		
		public function setState(state:int):void
		{
			_State = state;
		}
		
		public function get Connection():Point
		{
			return _Connection;
		}
		
		public function Update(Xoor:Number, Yoor:Number, Connection:Point, CostSoFar:Number, Heuristic:Number, State:int):void
		{
			_Coordinate.x = Xoor;
			_Coordinate.y = Yoor;
			_Connection = Connection;
			_CostSoFar = CostSoFar;
			_Heuristic = Heuristic;
			_EstimatedCost = _CostSoFar + _Heuristic;
			_State = State;
		}
	}
}


