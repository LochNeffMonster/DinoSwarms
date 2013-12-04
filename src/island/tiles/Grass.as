package island.tiles
{

import dinosaurs.Dinosaur;

import island.TileMap;

import util.Color;

public class Grass extends Tile{
	public static const EDIBLE_PERCENT:Number = .5;
	public static const GRASS_COLOR:Color = new Color(0.3, 1, 0.3);
	public static const DIRT_COLOR:Color = new Color(0.7, 0.5, 0.2);
	public static const GROWTH_RES:int = 32;
	
	private static const BEGIN_DELAY:int = 120;
	private static const UPDATE_PERIOD:int = 60;
	private static const EAT_UPDATE_PERIOD:int = 5;
	private static const EAT_RATE:Number = 0.01;	
	
	private static var _growthMap:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
	{
		initGrowthMap();
	}
	
	private var _growthPercent:Number = 0;
	private var _isEdible:Boolean ;
	private var _growRate:Number;
	
	private var _beingEaten:Boolean = false;
	
	public function Grass(ediblePercent:Number, growRate:Number){
		super();
		_traversable = true;
		_growthPercent = ediblePercent;
		_isEdible = (ediblePercent > EDIBLE_PERCENT);
		_growRate = growRate;
	}
	
	public override function onAddToTileMap():void{
		if(_growthPercent < 1  &&  _growRate > 0){
			requestUpdate((int)(Math.random()*BEGIN_DELAY + 1));
		}
		initGrassGrowth(_growthPercent);
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
	
	public function onEatGrass(d:Dinosaur):void {
		updateGrowth(Math.max(0, _growthPercent - d.EatRate));
		_isEdible = (_growthPercent > 0);
		
		_beingEaten = true;
		if(_plannedUpdates == 0){
			requestUpdate(EAT_UPDATE_PERIOD);
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
    
    public static function shuffleGrass():Array{
        var ary:Array = TileMap.CurrentMap.getTilesFromClass(Grass);
        var capy:Array = [];
        for(var j:int in ary){
            if(ary[j].IsEdible){
                capy.push(ary[j]);  
            }     
        }
        var shuffled:Array = new Array(capy.length);
        var randomPos:Number = 0;
        
        var sectors:Array = [];
        for(var k:int = 0; k < TileMap.WIDTH / GROWTH_RES; ++k){
            sectors[k] = [];
            for(var l:int = 0; l < TileMap.HEIGHT / GROWTH_RES; ++l){
                sectors[k][l] = [];
            }
        }
                
        for (var i:int = 0; i < shuffled.length; i++) //use shuffledLetters.length because splice() will change letters.length
        {
            randomPos = int(Math.random() * capy.length);
            //shuffled[i] = capy[randomPos];    //note this the other way around to the naive approach
            var g:Grass = capy[randomPos];
            (sectors[Math.floor(g.x/Grass.GROWTH_RES)][Math.floor(g.y/Grass.GROWTH_RES)]).push(g);
            capy.splice(randomPos, 1);
        }
        return sectors;
    }
	
	public static function getGrowthPercent(sectorX:int, sectorY:int):Number{
		return _growthMap[sectorX][sectorY];
	}
	
	private function grow():void {
		updateGrowth(_growthPercent + _growRate);
		_isEdible = _growthPercent > EDIBLE_PERCENT;
		if(_growthPercent >= 1){
			updateGrowth(1);
		}else{
			requestUpdate(UPDATE_PERIOD);
		}
	}
	
	private function updateGrowth(toGrowth:Number):void{
		var growthIndexX:int = x / GROWTH_RES;
		var growthIndexY:int = y / GROWTH_RES;
		_growthMap[growthIndexX][growthIndexY] += (toGrowth - _growthPercent) / (GROWTH_RES*GROWTH_RES);
		_growthPercent = toGrowth;
	}
	
	private function initGrassGrowth(initGrowth:Number):void{
		updateGrowth(initGrowth + _growthPercent);
		_growthPercent = initGrowth;
	}
	
	private static function initGrowthMap():void{
		_growthMap = new Vector.<Vector.<Number>>(TileMap.WIDTH / GROWTH_RES);
		var i:int = 0;
		var j:int = 0;
		for(i = 0; i<TileMap.WIDTH / GROWTH_RES; i++){
			_growthMap[i] = new Vector.<Number>(TileMap.HEIGHT / GROWTH_RES);
			for(j = 0; j<TileMap.HEIGHT / GROWTH_RES; j++){
				_growthMap[i][j] = 0;
			}
		}
	}
}
}