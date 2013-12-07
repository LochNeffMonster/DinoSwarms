package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import dinosaurs.Gallimimus;
	import dinosaurs.TRex;
	
	import island.TileMap;
	import island.generation.LevelGeneration;
	import island.generation.MarkovModel;
	import island.generation.layers.DirtBaseGenerationLayer;
	import island.generation.layers.MarkovGenerationLayer;
	import island.generation.layers.SmoothingLayer;
	import island.tiles.Grass;
	import island.tiles.Tile;
	import flash.display.Shape;
	
	public class DinoSwarms extends Sprite{
		private var _tileMap:TileMap;
		private var _generator:LevelGeneration;
		private var _acceptableGrowthLevel:Number = 0.8;
		
		public static var galHolder:Array = [];
		public static var trexHolder:Array = [];
		public static var grassArray:Array;
		
		private static var CountTRex:int;
		private static var CountGallimimus:int;
		
		private var formSprite:Sprite = new Sprite();
		private var submitSprite:Sprite = new Sprite();
		private var upBtnSpriteGali:Sprite = new Sprite();
		private var downBtnSpriteGali:Sprite = new Sprite();
		private var upBtnSpriteTRex:Sprite = new Sprite();
		private var downBtnSpriteTRex:Sprite = new Sprite();
		
		public function DinoSwarms(){
			initGenerator();
			
			_tileMap = new TileMap();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function initGenerator():void{
			_generator = new LevelGeneration();
			
			//Dirt layer
			var exampleLayer:DirtBaseGenerationLayer = new DirtBaseGenerationLayer();
			exampleLayer.addResolution(32); 
			_generator.addGenerationLayer(exampleLayer);
			
			//Biome Generation
			var biomeLayer:MarkovGenerationLayer = new MarkovGenerationLayer();
			biomeLayer.setMinMaxResolution(16, 1);
			var biomeModel:MarkovModel = new MarkovModel([[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 10, 0, 0, 0, 0, 0, 0],
				[0, .2, 80, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, .08, .05, 0, 0, 40, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]);
			biomeLayer.setModel(biomeModel, Tile.DIRT, Tile.GRASS);
			_generator.addGenerationLayer(biomeLayer);
			
			//Fractal Layer
			var fractalLayer:MarkovGenerationLayer = new MarkovGenerationLayer();
			fractalLayer.setMinMaxResolution(32, 1);
			var fractalModel:MarkovModel = new MarkovModel([[1, 0, 0, 0, 0, 0, 0, 0],
				[0, 1, 0, 0, 0, 0, 0, 0],
				[0, 0, 1, 0, 0, 0, 0, 0],
				[0, 0, 0, 0.8, 0, 0, 0, 0],
				[0, 0, 0, 0, 1, 0, 0, 0],
				[0, 0, 0, 0, 0, 1, 0, 0],
				[0, 0, 0, 0, 0, 0, 1.5, 0],
				[0, 0, 0, 0, 0, 0, 0, 1]]);
			fractalLayer.setModel(fractalModel, Tile.DIRT, Tile.GRASS, Tile.SAND, Tile.TREE, Tile.FOREST);
			_generator.addGenerationLayer(fractalLayer);
			
			//Beach Layer
			var beachLayer:MarkovGenerationLayer = new MarkovGenerationLayer();
			beachLayer.setMinMaxResolution(16, 1);
			var beachModel:MarkovModel = new MarkovModel([[1, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 3, .2, 0, .2, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]);
			beachLayer.setModel(beachModel, Tile.WATER);
			_generator.addGenerationLayer(beachLayer);
			
			
			//Laker Layer
			var lakeLayer:MarkovGenerationLayer = new MarkovGenerationLayer();
			lakeLayer.setMinMaxResolution(8, 8);        //w   d   g   s   t   f   l   b
			var lakeModel:MarkovModel = new MarkovModel([[1,  0,  0,  0,  0,  0,  0,  0],    // water 
				[0,  2,  0,  0,  0,  0,  0,  0],    // dirt
				[0,  0,  2,  0,  0,  0,  0,  0],    // grass
				[0,  0,  0,  1,  0,  0,  0,  0],    // sand
				[0,  0,  0,  0,  1,  0,  0,  0],    // tree
				[0,  0,  0,  0,  0,  1,  0,  0],    // forrest
				[0, .009, .009,  0, .009, .009,  5, .009],    // lake
				[0,  0,  0,  0,  0,  0,  0,  2]]);  //bush
			lakeLayer.setModel(lakeModel, Tile.DIRT, Tile.GRASS, Tile.FOREST, Tile.TREE, Tile.BUSH, Tile.LAKE);
			_generator.addGenerationLayer(lakeLayer);
			
			//Smoothing Layer		
			var smoothingLayer:SmoothingLayer = new SmoothingLayer(6);
			smoothingLayer.addResolution(1);
			_generator.addGenerationLayer(smoothingLayer);
			
			//Trees
			var treeLayer:MarkovGenerationLayer = new MarkovGenerationLayer(true);
			treeLayer.setMinMaxResolution(1, 1);
			var treeModel:MarkovModel = new MarkovModel([[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, -1, .1, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]);
			treeLayer.setModel(treeModel, Tile.FOREST);
			_generator.addGenerationLayer(treeLayer);		
		}
		
		private function init(e:Event):void {
			addChild(_tileMap);
			addEventListener(Event.ENTER_FRAME, stepGenerate);
		}
		
		private function stepGenerate(e:Event):void {
			_generator.stepGenerate(_tileMap);
			if(_generator.finished()){
				_generator.finalize(_tileMap);
				removeEventListener(Event.ENTER_FRAME, stepGenerate);
				generationFinished();
			}
		}
		
		private function generationFinished():void {
			
			var SubmitText:TextField = new TextField();
			var TextSubmit:String = "Submit";
			var GaliText:TextField = new TextField();
			var TextGali:String = "Initial Gallimimus Population = "+ CountGallimimus;
			var RexText:TextField = new TextField();
			var TextRex:String = "Initial T-Rex Population = "+ CountTRex;
			
			formSprite.graphics.beginFill(0x000000);
			formSprite.graphics.drawRect(0,0,225,130);
			formSprite.graphics.endFill();
			formSprite.x = 20;
			formSprite.y = 40;
			addChild(formSprite);
			
			
			
			SubmitText.text = TextSubmit;
			SubmitText.textColor = 0x00FFFF;
			submitSprite.addChild(SubmitText);
			
			GaliText.text = TextGali;
			GaliText.x = 25;
			GaliText.y = 55;
			GaliText.width = 200;
			GaliText.textColor = 0x00FFFF;
			addChild(GaliText);
			
			RexText.text = TextRex;
			RexText.x = 25;
			RexText.y = 130;
			RexText.width = 200;
			RexText.textColor = 0x00FFFF;
			addChild(RexText);
			
			
			var triangleHeight:uint = 18;
			var triangleShapeUp:Shape = new Shape();
			triangleShapeUp.graphics.beginFill(0xFFFFFF);
			triangleShapeUp.graphics.moveTo(triangleHeight/2, 5);
			triangleShapeUp.graphics.lineTo(triangleHeight, triangleHeight+5);
			triangleShapeUp.graphics.lineTo(0, triangleHeight+5);
			triangleShapeUp.graphics.lineTo(triangleHeight/2, 5);
			triangleShapeUp.x = 220;
			triangleShapeUp.y = 42;
			addChild(triangleShapeUp);
			
			
			upBtnSpriteGali.graphics.beginFill(0x000000);
			upBtnSpriteGali.graphics.drawRect(0,0,20,20);
			upBtnSpriteGali.graphics.endFill();
			upBtnSpriteGali.alpha = 0;
			upBtnSpriteGali.x = 220;
			upBtnSpriteGali.y = 45;
			addChild(upBtnSpriteGali);
			upBtnSpriteGali.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				CountGallimimus++;
				GaliText.text = "Initial Gallimimus Population = " + CountGallimimus;
			});
			
			var triangleShapeDown:Shape = new Shape();
			triangleShapeDown.graphics.beginFill(0xFFFFFF);
			triangleShapeDown.graphics.moveTo((-triangleHeight)/2, 5);
			triangleShapeDown.graphics.lineTo((-triangleHeight), (-triangleHeight)+5);
			triangleShapeDown.graphics.lineTo(0, (-triangleHeight)+5);
			triangleShapeDown.graphics.lineTo((-triangleHeight)/2, 5);
			triangleShapeDown.x = 238;
			triangleShapeDown.y = 80;
			addChild(triangleShapeDown);
			
			
			
			downBtnSpriteGali.graphics.beginFill(0x00FFFF);
			downBtnSpriteGali.graphics.drawRect(0,0,20,20);
			downBtnSpriteGali.graphics.endFill();
			downBtnSpriteGali.x = 220;
			downBtnSpriteGali.y = 70;
			downBtnSpriteGali.alpha = 0;
			addChild(downBtnSpriteGali);
			downBtnSpriteGali.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				if(CountGallimimus > 0){
					CountGallimimus--;
					GaliText.text = "Initial Gallimimus Population = " + CountGallimimus;
				}
			});
			
			
			var triangleUp:Shape = new Shape();
			triangleUp.graphics.beginFill(0xFFFFFF);
			triangleUp.graphics.moveTo(triangleHeight/2, 5);
			triangleUp.graphics.lineTo(triangleHeight, triangleHeight+5);
			triangleUp.graphics.lineTo(0, triangleHeight+5);
			triangleUp.graphics.lineTo(triangleHeight/2, 5);
			triangleUp.x = 220;
			triangleUp.y = 114;
			addChild(triangleUp);
			
			downBtnSpriteTRex.graphics.beginFill(0xFF00FF);
			downBtnSpriteTRex.graphics.drawRect(0,0,20,20);
			downBtnSpriteTRex.graphics.endFill();
			downBtnSpriteTRex.x = 220;
			downBtnSpriteTRex.y = 115;
			downBtnSpriteTRex.alpha = 0;
			addChild(downBtnSpriteTRex);
			downBtnSpriteTRex.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				CountTRex++;
				RexText.text = "Initial T-Rex Population = " + CountTRex;
			});
			
			var triangleDown:Shape = new Shape();
			triangleDown.graphics.beginFill(0xFFFFFF);
			triangleDown.graphics.moveTo((-triangleHeight)/2, 5);
			triangleDown.graphics.lineTo((-triangleHeight), (-triangleHeight)+5);
			triangleDown.graphics.lineTo(0, (-triangleHeight)+5);
			triangleDown.graphics.lineTo((-triangleHeight)/2, 5);
			triangleDown.x = 238;
			triangleDown.y = 152;
			addChild(triangleDown);
			
			upBtnSpriteTRex.graphics.beginFill(0x00FFFF);
			upBtnSpriteTRex.graphics.drawRect(0,0,20,20);
			upBtnSpriteTRex.graphics.endFill();
			upBtnSpriteTRex.x = 220;
			upBtnSpriteTRex.y = 142;
			upBtnSpriteTRex.alpha = 0;
			addChild(upBtnSpriteTRex);
			upBtnSpriteTRex.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				if(CountTRex > 0){
					CountTRex--;
					RexText.text = "Initial T-Rex Population = " + CountTRex;
				}
			});
			
			submitSprite.graphics.beginFill(0x000000);
			submitSprite.graphics.drawRect(0,0,38,20);
			submitSprite.graphics.endFill();
			submitSprite.x = 110;
			submitSprite.y = 180;
			addChild(submitSprite);
			submitSprite.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				removeChild(GaliText);
				removeChild(RexText);
				removeChild(upBtnSpriteGali);
				removeChild(downBtnSpriteGali);
				removeChild(upBtnSpriteTRex);
				removeChild(downBtnSpriteTRex);
				removeChild(submitSprite);
				removeChild(formSprite);
				removeChild(triangleDown);
				removeChild(triangleUp);
				removeChild(triangleShapeDown);
				removeChild(triangleShapeUp);
				generateDinosaurs();
			});
		}
		
		private function generateDinosaurs():void {
			// Search for a fertile place to put the dinos
			// 		using the list of grass tiles, randomly place the dinos
			grassArray = _tileMap.getTilesFromClass(Grass);
			var randomIndex:int;
			
			for(var i:int = 0; i<CountGallimimus;i++){
				randomIndex = Math.floor(Math.random()*grassArray.length);
				var dino:Gallimimus = new Gallimimus((grassArray[randomIndex]).x, (grassArray[randomIndex]).y);
			}
			
			for(var j:int = 0; j<CountTRex;++j){
				randomIndex = Math.floor(Math.random()*grassArray.length);
				var trex:TRex = new TRex(grassArray[randomIndex].x, grassArray[randomIndex].y);
			}
		}
	}
}