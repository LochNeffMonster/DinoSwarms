package
{
    import flash.display.Sprite;
    import flash.events.Event;
    
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
    
    public class DinoSwarms extends Sprite{
        private var _tileMap:TileMap;
		private var _generator:LevelGeneration;
		private var _acceptableGrowthLevel:Number = 0.8;
        
        public static var galHolder:Array = [];
        public static var trexHolder:Array = [];
        
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
		
		private function stepGenerate(e:Event):void{
			_generator.stepGenerate(_tileMap);
			if(_generator.finished()){
				_generator.finalize(_tileMap);
				removeEventListener(Event.ENTER_FRAME, stepGenerate);
				generationFinished();
			}
		}
		
		private function generationFinished():void{
			// Search for a fertile place to put the dinos
			// 		using the list of grass tiles, randomly place the dinos
			var grassArray:Array = _tileMap.getTilesFromClass(Grass);
            var randomIndex:int;
			for(var i:int = 0; i<15;i++){
				var dino:Gallimimus = new Gallimimus();
				randomIndex = Math.floor(Math.random()*grassArray.length);
				dino.x = (grassArray[randomIndex]).x;
				dino.y = (grassArray[randomIndex]).y;
				TileMap.CurrentMap.addChild(dino);
                galHolder.push(dino);
			}
            
            for(var j:int = 0; j<1;++j){
                var trex:TRex = new TRex();
                randomIndex = Math.floor(Math.random()*grassArray.length);
                trex.x = (grassArray[randomIndex]).x;
                trex.y = (grassArray[randomIndex]).y;
                TileMap.CurrentMap.addChild(trex);
                trexHolder.push(trex);
            }
		}
    }
}