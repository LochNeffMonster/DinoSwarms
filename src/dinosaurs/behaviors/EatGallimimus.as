package dinosaurs.behaviors
{
    import dinosaurs.Dinosaur;
    import dinosaurs.TRex;
    
    public class EatGallimimus extends Behavior
    {
        public function EatGallimimus(dino:Dinosaur)
        {
            super(dino);
        }
        
        public function eat():void {
            (_dinosaur as TRex).CurrentCorpse.percentEaten += _dinosaur.EatRate;
			_dinosaur.energy += 0.5;
            trace("Eating: " + (_dinosaur as TRex).CurrentCorpse.percentEaten);
        }
    }
}