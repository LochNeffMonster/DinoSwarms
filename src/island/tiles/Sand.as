package island.tiles
{
import util.Color;

public class Sand extends Tile{
	public static const SAND_COLOR:Color = new Color(1, 1, 0.5);
	
	public function Sand()
	{
		super();
		_traversable = true;
	}
	
	public override function getColor():uint {
		return SAND_COLOR.color;
	}
}
}