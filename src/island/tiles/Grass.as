package island.tiles
{

import util.Color;

public class Grass extends Tile
{
	public static var grass:Grass;
	
	public static const EDIBLE_PERCENT:Number = .5;
	private static const EAT_RATE:Number = 0.01;
	public static const GRASS_COLOR:Color = new Color(0.2, 1, 0.2);
	public static const DIRT_COLOR:Color = new Color(0.5, 0.3, 0);
	
	private static const BEGIN_DELAY:int = 120;
	private static const UPDATE_PERIOD:int = 60;
	private static const EAT_UPDATE_PERIOD = 5;
	
	private var _growthPercent:Number;
	private var _isEdible:Boolean;
	private var _growRate:Number;
	
	private var _beingEaten:Boolean = false;
	
	public function Grass(ediblePercent:Number, growRate:Number){
		super();
		grass = this;
		_traversable = true;
		_growthPercent = ediblePercent;
		_isEdible = (ediblePercent > EDIBLE_PERCENT);
		_growRate = growRate;
	}
	
	public override function getColor():uint {
		return DIRT_COLOR.tween(GRASS_COLOR, _growthPercent);
	}
	
	public function get EdiblePercent():Number {
		return _growthPercent;
	}
	
	public function get IsEdible():Boolean {
		return _isEdible;
	}
	
	public function onEatGrass():void {
		trace(_isEdible);
		_growthPercent = Math.max(0, _growthPercent - EAT_RATE);
		_isEdible = (_growthPercent > 0);
		
		_beingEaten = true;
		if(_plannedUpdates == 0){
			requestUpdate(EAT_UPDATE_PERIOD);
		}
	}
	
	private function grow():void {
		_growthPercent += _growRate;
		_isEdible = _growthPercent > EDIBLE_PERCENT;
		if(_growthPercent >= 1){
			_growthPercent = 1;
		}else{
			requestUpdate(UPDATE_PERIOD);
		}
	}
	
	public override function onAddToTileMap():void{
		if(_growthPercent < 1  &&  _growRate > 0){
			requestUpdate((int)(Math.random()*BEGIN_DELAY + 1));
		}
	}
	
	public override function onUpdate():void {
		super.onUpdate();
		
		if(_beingEaten){
			_beingEaten = false;
			requestUpdate(EAT_UPDATE_PERIOD);
		}else{
			grow();
		}
	}
}
}