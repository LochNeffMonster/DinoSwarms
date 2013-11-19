package util{

public class Color{
	private var _red:Number;
	private var _green:Number;
	private var _blue:Number;
	
	private var _fresh:Boolean = false;
	private var _color:uint;
	
	/**Constructs a new Color object with the given color channels,
	 * each ranging from 0 to 1
	 */
	public function Color(red:Number, green:Number, blue:Number){
		setColor(red, green, blue);
	}
	
	/**Returns the red component of this color
	 * 
	 * @return red component from 0 to 1
	 */
	public function get red():Number{
		return _red;
	}
	
	/**Returns the green component of this color
	 * 
	 * @return green component from 0 to 1
	 */
	public function get green():Number{
		return _green;
	}
	
	/**Returns the blue component of this color
	 * 
	 * @return blue component from 0 to 1
	 */
	public function get blue():Number{
		return _blue;
	}
	
	/**Returns the Actionscript style version of this color
	 * 
	 * @return this color represented as a uint
	 */
	public function get color():uint{
		if(!_fresh){
			_color = (uint)(_red*255) << 16 | (uint)(_green*255) << 8 | (uint)(_blue*255);
			_fresh = true;
		}
		return _color;
	}
	
	/**Sets the value of this color equal to the given Actionscript
	 * style color
	 * 
	 * @param color in a uint
	 */
	public function set color(color:uint):void{
		_color = color;
		_red = (_color >> 16) / 255.0;
		_green = (_color >> 8 & 0xFF) / 255.0;
		_blue = (_color & 0xFF) / 255.0		
	}
	
	/**Sets each channel of this color in a single method
	 * 
	 * @param red channel from 0 to 1
	 * @param green channel from 0 to 1
	 * @param blue channel from 0 to 1
	 */
	public function setColor(red:Number, green:Number, blue:Number):void{
		_red = red;
		_green = green;
		_blue = blue;
		_fresh = false;
	}
	
	/**Returns a color between this color and a given color.
	 * 
	 * @param color to interpolate between
	 * @param percent of the destination color to use
	 * @return Actionscript color result of the interpolation
	 */
	public function tween(color:Color, percent:Number):uint{
		var r:Number = _red * (1 - percent) + color.red * percent;
		var g:Number = _green * (1 - percent) + color.green * percent;
		var b:Number = _blue * (1 - percent) + color.blue * percent;
		return _color = (uint)(r*255) << 16 | (uint)(g*255) << 8 | (uint)(b*255);
	}
	
}
}