package dinosaurs.behaviors
{
    import dinosaurs.Dinosaur;
    import island.TileMap;
    import events.TileEvent;
    
    public class Eat extends Behavior
    {
		private var _dino:Dinosaur;
		
        public function Eat(dino:Dinosaur)
        {
			
            super(dino);
			_dino = dino;
		}
        
        public function eat():void {
            //eat shit fucking god damn
			TileMap.CurrentMap.dispatchEvent(new TileEvent(TileEvent.EAT_GRASS,_dino.x , _dino.y) );
			trace("om nom nom nom nom nom");
        }
    }
}