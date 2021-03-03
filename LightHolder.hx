 package entities.interfaces;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

/**
 * @author Isaac
 */
interface LightHolder 
{
	public var lr:Int;
	public var lightColor:Array<Int>;
	public var brightness:Int;
	public var falloff:Int;
	public function getCenterXY():FlxPoint;  
	public function getScreenPosition(?point:FlxPoint, ?Camera:FlxCamera):FlxPoint;
	
}