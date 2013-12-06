package dinosaurs.Engines
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import dinosaurs.Dinosaur;
	import dinosaurs.Engines.Node;
	
	import island.TileMap;
	import island.tiles.Tile;
	
	public class AStar
	{
		private static var currentAStar:AStar;
		
		protected var _nodePos:Array; //quick Node pos look up
		protected var _allNodes:Array; //quick Node look up
		protected var _openList:Array; // Looked at Nodes
		protected var _start:Node; //Starting Node
		protected var _end:Point; //Ending coordinates
		protected var _currentNode:Node; //Current Node being processed
		protected var _nodeDictionary:Dictionary = new Dictionary();
		
		protected var _dino:Dinosaur; //needed for different pathing costs 
		
		{
			currentAStar = new AStar();
		}
		
		public function AStar(){

			_nodePos = []; //quick Node pos look up
			_allNodes = []; //quick Node look up
			for(var i:int = 0; i<TileMap.WIDTH; ++i){
				_nodePos.push([]);
				_allNodes.push([]);
			}

		}
		
		public static function get CurrentAStar():AStar {
			return currentAStar;
		}
		
		public function GeneratePath(startX:int, startY:int, endX:int, endY:int, dino:Dinosaur):Array
		{
			if (endX < 0 || endY < 0 || endX == TileMap.WIDTH ||
				endY == TileMap.HEIGHT || !TileMap.CurrentMap.getTile(endX, endY).getTraversable)
				return null;
			
			startX = Math.floor(startX);
			startY = Math.floor(startY);
			endX = Math.floor(endX);
			endY = Math.floor(endY);

			//setting variables and current node
			_dino = dino;
			_openList = [];
			for(var i:int = 0; i<TileMap.WIDTH; ++i){
				for(var j:int = 0; j<TileMap.HEIGHT; ++j){
					_nodePos[i][j] = 0;
					_allNodes[i][j] = 0;
				}
			}
			_end = new Point(endX,endY);
			if (!_nodeDictionary[(startY * TileMap.WIDTH + startX)]){
				_nodeDictionary[(startY * TileMap.WIDTH + startX)] = new Node(startX, startY, null, 0, GenerateHeuristic(startX, startY), 1);
			}
			else
			{
				_nodeDictionary[(startY * TileMap.WIDTH + startX)].Update(startX, startY, null, 0, GenerateHeuristic(startX, startY), 1);
			}
			
			_start = _nodeDictionary[(startY * TileMap.WIDTH + startX)];
			_currentNode = _start;
			//start at position 1 to make later math easier
			_openList[1] = _nodeDictionary[(startY * TileMap.WIDTH + startX)];
			_allNodes[startX][startY] = _start;
			_nodePos[startX][startY] = 1;
			
			//core path finding loop
			while(_openList.length > 0)
			{

				
				//next node always at top of priority heap
				_currentNode = _openList[1];
				PopOpenList();
				var _Pos:Point = _currentNode.Coordinate;
				//did we reach our goal?
				if (_Pos.x == _end.x && _Pos.y == _end.y)
				{
					trace("broke out of it");
					break;
				}
				
				//Loop through all Neighbors
				for (var i:int = -1; i < 2; i++)
				{
					for (var j:int = -1; j < 2; j++)
					{
						//don't count the current node
						if (i == 0 && j == 0)
						{continue;}
						
						if(_Pos.x + i < 0 || _Pos.y + j < 0 || _Pos.x + i == TileMap.WIDTH || _Pos.y + j == TileMap.HEIGHT) 
						{continue;}
						//don't count untraversable nodes
						if (!TileMap.CurrentMap.getTileFromCoord(_Pos.x + i, _Pos.y + j).getTraversable()) 
						{continue;}
						
						if (!_nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))]){
							_nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))] = 
								new Node(_Pos.x + i, _Pos.y + j, _Pos, _currentNode.CostSoFar
								+ GenerateCost(TileMap.CurrentMap.getTile(_Pos.x + i, _Pos.y + j)),
								GenerateHeuristic(_Pos.x + i, _Pos.y + j), 1);
						}

						
						//var tempNode:Node = _nodeDictionary[(_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i)];
						
						if (_allNodes[(_Pos.x + i)][(_Pos.y + j)] is Node) {
							
							if (_currentNode.Connection != _allNodes[(_Pos.x + i)][(_Pos.y + j)].Coordinate &&
								_allNodes[(_Pos.x + i)][(_Pos.y + j)].EstimatedCost > _currentNode.CostSoFar
								+ GenerateCost(TileMap.CurrentMap.getTile(_Pos.x + i, _Pos.y + j)))
							{

								trace("we ran into the same node ok?!?!?!");
								if (_allNodes[(_Pos.x + i)][(_Pos.y + j)].State == 1)
								{
									_nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))].Update(_Pos.x + i, _Pos.y + j, _Pos, _currentNode.CostSoFar
										+ GenerateCost(TileMap.CurrentMap.getTile(_Pos.x + i, _Pos.y + j)),
										GenerateHeuristic(_Pos.x + i, _Pos.y + j), 1);
									UpdateOpenList(_nodeDictionary[(_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i)]);
									_allNodes[(_Pos.x + i)][(_Pos.y + j)] = _nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))];
								}
								else
								{
									_nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))].Update(_Pos.x + i, _Pos.y + j, _Pos, _currentNode.CostSoFar
										+ GenerateCost(TileMap.CurrentMap.getTile(_Pos.x + i, _Pos.y + j)),
										GenerateHeuristic(_Pos.x + i, _Pos.y + j), 1);
									AddOpenList(_nodeDictionary[(_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i)]);
									_allNodes[(_Pos.x + i)][(_Pos.y + j)] = _nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))];
								}
							}
							else
								continue;
						}
						else
						{
							_nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))].Update(_Pos.x + i, _Pos.y + j, _Pos, _currentNode.CostSoFar
								+ GenerateCost(TileMap.CurrentMap.getTile(_Pos.x + i, _Pos.y + j)),
								GenerateHeuristic(_Pos.x + i, _Pos.y + j), 1);
							AddOpenList(_nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))]);
							_allNodes[(_Pos.x + i)][(_Pos.y + j)] = _nodeDictionary[((_Pos.y + j) * TileMap.WIDTH + (_Pos.x + i))];
						}
					}
				}
				if (_openList.length == 2)
					break;
				

				
				_currentNode.setState(2);
				_allNodes[_Pos.x][_Pos.y] = _currentNode;
			}
			if (_Pos.x != _end.x && _Pos.y != _end.y )
			{
				return null;
			}
				
			else
			{
				var returnList:Array = [];
				returnList[0] = _end;
				returnList[1] = _currentNode.Coordinate;
				while (_currentNode != _start)
				{
					_currentNode = _allNodes[_currentNode.Connection.x][_currentNode.Connection.y];
					returnList[returnList.length] = _currentNode.Coordinate;
				}
				
				return returnList;
			}
		}
		
		private function AddOpenList(NewNode:Node):void
		{
			trace("Bacon Supreme");
			//get last position in open list and Estimated Cost of the new node
			var newCost:Number = NewNode.EstimatedCost;
			var currPos:int = _openList.length;
			
			_openList[currPos] = NewNode;
			var parentNode:int = currPos / 2;
			//sorts the new node up the tree based on its cost
			while (true)
			{
				if (currPos != 1 && newCost < _openList[parentNode].EstimatedCost)
				{
					_openList[currPos] = _openList[parentNode];
					_openList[parentNode] = NewNode;
					_nodePos[_openList[currPos].Coordinate.x][_openList[currPos].Coordinate.y] = currPos;
					currPos = parentNode;
					parentNode = currPos / 2;
					_nodePos[NewNode.Coordinate.x][NewNode.Coordinate.y] = currPos;
				}
					
				else
				{
					_nodePos[NewNode.Coordinate.x][NewNode.Coordinate.y] = currPos;
					break;
				}
			}
			
		}
		
		private function PopOpenList():void
		{
			var currPos:int = 1;
			if(!_openList[_openList.length-1]){
				trace("wtf");
			}
			var tmpNode:Node;
			//while(!tmpNode){
				tmpNode = _openList.pop();
			//}
			if (tmpNode == null)
				trace("Tracey Larabee");
			_openList[1] = tmpNode;
			while (true)
			{
				if(!_openList[ (2*currPos)]) break;
				else if(_openList[ (2*currPos)] && !_openList[ ((2*currPos) + 1)]){
					if (tmpNode.EstimatedCost > _openList[ (2 * currPos)].EstimatedCost)
					{
						_openList[currPos] = _openList[ (2 * currPos)];
						_openList[ (2 * currPos)] = tmpNode;
						_nodePos[_openList[currPos].Coordinate.x][_openList[currPos].Coordinate.y] = currPos;
						_nodePos[_openList[(2 * currPos)].Coordinate.x][_openList[(2 * currPos)].Coordinate.y] = (2 * currPos);
						currPos = 2 * currPos;
					}
						
					else
					{
						break;
					}
				}
				else if (_openList[ (2 * currPos)].EstimatedCost < _openList[ ((2 * currPos) + 1)].EstimatedCost)
				{
					if (tmpNode.EstimatedCost > _openList[ (2 * currPos)].EstimatedCost)
					{
						_openList[currPos] = _openList[ (2 * currPos)];
						_openList[ (2 * currPos)] = tmpNode;
						_nodePos[_openList[currPos].Coordinate.x][_openList[currPos].Coordinate.y] = currPos;
						_nodePos[_openList[(2 * currPos)].Coordinate.x][_openList[(2 * currPos)].Coordinate.y] = (2 * currPos);
						currPos = 2 * currPos;
					}
						
					else
					{
						break;
					}
				}
				else
				{
					if (tmpNode.EstimatedCost > _openList[ ((2 * currPos) + 1)].EstimatedCost)
					{
						_openList[currPos] = _openList[ ((2 * currPos) + 1)];
						_openList[ ((2 * currPos) + 1)] = tmpNode;
						_nodePos[_openList[currPos].Coordinate.x][_openList[currPos].Coordinate.y] = currPos;
						_nodePos[_openList[((2 * currPos) + 1)].Coordinate.x][_openList[((2 * currPos) + 1)].Coordinate.y] = ((2 * currPos) + 1);
						currPos = 2 * currPos + 1;
					}
						
					else
					{
						break;
					}
				}
			}
		}
		
		private function UpdateOpenList(RefNode:Node):void
		{

			trace("testingkgfdjlag");
			if (RefNode == null)
				trace("dafuq");
			
			var newCost:Number = RefNode.EstimatedCost;
			var currPos:int = _nodePos[RefNode.Coordinate.x][RefNode.Coordinate.y];
			
			_openList[currPos] =RefNode;
			
			//sorts the ref node up the tree based on its cost
			while (true)
			{
				if (currPos == 1)
				{
					_nodePos[RefNode.Coordinate.x][RefNode.Coordinate.y] = currPos;
					break;
				}
					
				else if (newCost < _openList[(int)(currPos / 2)].EstimatedCost)
				{
					_openList[currPos] = _openList[(int)(currPos / 2)];
					_openList[(int)(currPos / 2)] = RefNode;
					_nodePos[_openList[currPos].Coordinate.x][_openList[currPos].Coordinate.y] = currPos;
					_nodePos[_openList[(int)(currPos / 2)].Coordinate.x][_openList[(int)(currPos / 2)].Coordinate.y] = (int)(currPos / 2);
					currPos = currPos / 2;
				}
					
				else
				{
					_nodePos[RefNode.Coordinate.x][RefNode.Coordinate.y] = currPos;
					break;
				}
			}
			
		}
		
		private function GenerateCost(tile:Tile):int
		{
			return _dino.MoveCost(tile);
		}
		
		private function GenerateHeuristic(nodeX:int, nodeY:int):Number{
			//Uses Euclidain distance as heuristic
			//Currently just a linear 1:1 cost
			var dx:Number = Math.abs(_end.x - nodeX);
			var dy:Number = Math.abs(_end.y - nodeY);
			return Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
		}
		
	}
}

