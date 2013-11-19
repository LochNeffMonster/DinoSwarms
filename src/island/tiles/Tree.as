package island.tiles
{
public class Tree extends Tile{
	public function Tree(){
		super();
		_traversable = false;
	}
	
	public override function getColor():uint {
		return 0x5C3D00;
	}
}
}