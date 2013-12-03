package dinosaurs.Engines
{
	import flash.geom.Point;
	
	import dinosaurs.Dinosaur;

	public class VectorEngine
	{
		private static var currentVectorEngine:VectorEngine;
		
		private var repulseDistance:int = 10;
		
		{
			currentVectorEngine = new VectorEngine();
		}
		
		public function VectorEngine()
		{
		}
		
		public static function get CurrentVectorEngine():VectorEngine
		{
			return currentVectorEngine;
		}
		
		/**
		 * Used to move/find vector for opposite direction of some point.
		 */
		public function PolarVector(entity:Point, repulsor:Point):Vector.<Point>
		{
			//get difference between two points
			var target:Point = new Point(entity.x - repulsor.x, entity.y - repulsor.y);
			//get hypontenues
			var hypno:Number = Math.sqrt(Math.pow(target.x , 2) + Math.pow(target.y, 2));
			//use repulse distance to determine strength of repulsion
			// > repulse distance = weak; < repulse distance = strong
			hypno = hypno / repulseDistance;
			hypno = repulseDistance / hypno;
			target.x = target.x * hypno;
			target.y = target.y * hypno;
			//get target
			target.x += entity.x;
			target.y += entity.y;
			//initialize returning vector (could be cleaner)
			var returnVector:Vector.<Point> = new Vector.<Point>;
			returnVector[0] = entity;
			returnVector[1] = target;
			return returnVector;
		}
		
		/**
		 * Way of combining vectors to get a compromise vector.
		 * Half's by default
		 */
		public function MidVector(mainVector:Vector.<Point>, minorVector:Vector.<Point>, weight:int = 2):Vector.<Point>
		{
			//get the diffrences in the x and y between the two vectors
			//half that and store it in minorVector[1] (because the memory is already there)
			minorVector[1] = new Point((minorVector[1].x - mainVector[1].x) /weight, (minorVector[1].y - mainVector[1].y) /weight);
			//update mainVector by updating the target point with difference halved.
			//equally opposing vectors will result in the starting point (mainVector[0])
			mainVector[1] = new Point(mainVector[1].x + minorVector[1].x, mainVector[1].y + minorVector[1].y);
			return mainVector;
		}
		
		/**
		 * Secondary Flocking Behavior
		 * Scatter from fellow Galimimus
		 */
		public function ScatterTurkeys(location:Point, range:Number):Vector.<Point>
		{
			//Primary Vectors
			var masterVector:Vector.<Point> = new Vector.<Point>;
			var minorVector:Vector.<Point> = new Vector.<Point>;
			masterVector[0] = location;
			masterVector[1] = location;
			//keeps track of number of Turkeys in range
			var tick:int = 0;

			for each(var d:Dinosaur in DinoSwarms.galHolder)
			{
				//For each Turkey in range, repulses and comprimises vectors
				if (Math.sqrt(Math.pow(d.x, 2) + Math.pow(d.y , 2)) <= range)
				{
					tick += 1;
					minorVector = PolarVector(masterVector[0], new Point(d.x, d.y));
					masterVector = MidVector(masterVector, minorVector, tick);
				}
			}
			return masterVector;
		}
	}
}