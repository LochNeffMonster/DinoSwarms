package island.tiles
{

import util.Color;

public class Grass extends Tile
{
	public static const EDIBLE_PERCENT:Number = .5;
	private static const EAT_RATE:Number = 0.001;
	private static const GRASS_COLOR:Color = new Color(0.2, 1, 0.2);
	private static const DIRT_COLOR:Color = new Color(0.5, 0.3, 0);
	
	private var _growthPercent:Number;
	private var _isEdible:Boolean;
	private var _growRate:Number;
	
	
	public function Grass(ediblePercent:Number, growRate:Number){
		super();
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
		_growthPercent = Math.max(0, _growthPercent - EAT_RATE);
		_isEdible = (_growthPercent > 0);
	}
	
	private function grow():void {
		_growthPercent += _growRate;
		_isEdible = _growthPercent > EDIBLE_PERCENT;
		if(_growthPercent >= 1){
			_growthPercent = 1;
		}else{
			tilemap.requestUpdate(this, 60);
		}
	}
	
	public override function onAddToTileMap():void{
		if(_growthPercent < 1  &&  _growRate > 0){
			tilemap.requestUpdate(this, (int)(Math.random()*120 + 1));
		}
	}
	
	public override function onUpdate():void {
		grow();
	}
}
}