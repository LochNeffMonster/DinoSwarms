package dinosaurs.behaviors
{
    import dinosaurs.Dinosaur;
    import island.TileMap;
    import events.TileEvent;
    
    public class Eat extends Behavior
    {		
        public function Eat(dino:Dinosaur)
        {
			
            super(dino);
		}
        
        public function eat():void {
            //eat shit fucking god damn
			TileMap.CurrentMap.dispatchEvent(new TileEvent(TileEvent.EAT_GRASS,_dinosaur.x , _dinosaur.y, false, false, _dinosaur) );
			_dinosaur.energy += 0.5;
			//trace("om nom nom nom nom nom");
        }
    }
}