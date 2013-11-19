package
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    import dinosaurs.Gallimimus;
    
    import island.TileMap;
    import island.generation.LevelGeneration;
    import island.generation.layers.RandomGenerationLayer;
    
    public class DinoSwarms extends Sprite
    {
        private var tileMap:TileMap;
		private var generator:LevelGeneration;
        
        public function DinoSwarms(){
			generator = new LevelGeneration();
			var exampleLayer:RandomGenerationLayer = new RandomGenerationLayer();
			exampleLayer.addResolution(1);
			generator.addGenerationLayer(exampleLayer);
			
			tileMap = new TileMap();
			
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event):void {
            addChild(tileMap);
			addEventListener(Event.ENTER_FRAME, stepGenerate);
        }
		
		private function stepGenerate(e:Event):void{
			generator.stepGenerate(tileMap);
			if(generator.finished()){
				removeEventListener(Event.ENTER_FRAME, stepGenerate);
				generationFinished();
			}
		}
		
		private function generationFinished():void{
			var dino:Gallimimus = new Gallimimus();
			addChild(dino);
		}
    }
}