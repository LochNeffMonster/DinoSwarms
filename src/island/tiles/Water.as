package island.tiles
{
public class Water extends Tile{
	public function Water(){
		super();
		_traversable = false;
	}
	
	public override function getColor():uint {
		return 0x3333FF;
	}
}
}