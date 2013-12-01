package dinosaurs
{
    import flash.display.Sprite;
    
    import island.TileMap;
    
    public class Corpse extends Sprite
    {
        public var percentEaten:Number = 0;
        
        public function Corpse()
        {
            super();
            graphics.beginFill(0x00FFF0);
            graphics.drawRect(0,0,TileMap.TILE_SIZE*5,TileMap.TILE_SIZE*5);
            graphics.endFill();
        }
    }
}