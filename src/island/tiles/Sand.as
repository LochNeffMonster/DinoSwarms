package island.tiles
{
public class Sand extends Tile{
	public function Sand()
	{
		super();
		_traversable = true;
	}
	
	public override function getColor():uint {
		return 0xFFF5A2;
	}
}
}