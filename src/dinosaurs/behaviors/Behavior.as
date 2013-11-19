package dinosaurs.behaviors
{
    import dinosaurs.Dinosaur;

    public class Behavior
    {
        protected var _dinosaur:Dinosaur;
        
        public function Behavior(dino:Dinosaur)
        {
            _dinosaur = dino;
        }
    }
}