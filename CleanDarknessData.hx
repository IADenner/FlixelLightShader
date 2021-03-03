package shaders.darknessPrototypes;

import entities.Entity;
import entities.Player;
import entities.interfaces.LightHolder;
import flash.display.Sprite;
import flixel.FlxCamera;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import gameTools.GroupManager;
import gameTools.MyCamera;
import gameTools.PlayState;

/**
 * ...darknessdata with no camera rotation support
 * @author Isaac
 */
class CleanDarknessData extends FlxSprite 
{
	var sCamera:FlxCamera;
	var flxGroup:FlxTypedGroup<FlxSprite>;
	public function new(thisCamera:FlxCamera, group:FlxTypedGroup<Sprite>) 
	{
		super(100, 100, AssetPaths.darknesstexture__png);
		loadGraphic(AssetPaths.darknesstexture__png);
		
		sCamera = thisCamera;
		flxGroup = group;
	}
	
	
	var firstX:Int;
	var firstY:Int;
	
	public var brightness:Float;
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		var currentLightHolderIndex:Int = 0;
		
		//Shader supports a maximum of 128 lighting sources, although could easily be scaled up with a larger texture.
		//The first row of pixels holds x and y PERCENTAGES of location - so if an object is halfway across the camera on the x axis, x = 0.5. Likewise, three quarters down the screen is y = 0.75. 
		for (i in 0...127)
		{
			
			
			var b:Int = 0;
			var r:Int = 0;
			
			var lholder:LightHolder = cast flxGroup.members[currentLightHolderIndex];
			
			//variable holds whether or not lholder is on screen, null safety check
			var isLHolderOnScreen = (lholder ! = null && (lholder.getScreenPosition(sCamera).x > sCamera.width || lholder.getScreenPosition(sCamera).x < 0 || lholder.getScreenPosition(sCamera.y) > sCamera.height || lholder.getScreenPosition(sCamera).y < 0));
			while (currentLightHolderIndex < flxGroup.members.length &&  || isLHolderOnScreen == false))
			{
				currentLightHolderIndex += 1;
				lholder = cast GroupManager.lightEmitterGroup.members[currentLightHolderIndex];
			}
			
			if (lholder == null || currentLightHolderIndex > GroupManager.lightEmitterGroup.members.length)
			{
				pixels.setPixel32(i, 0, 0);
				pixels.setPixel32(i, 1, 0);
			}
			else 
			{
				//opoint will hold the original (unscaled) point on the camera screen of our entity.
				var opoint:FlxPoint = FlxPoint.get(0, 0);		
				opoint = lholder.getScreenPosition(sCamera);
				r = lholder.lr;
				b = lholder.brightness;
				
				
				//since the rgb values scale between 0-255, multiply our screen percentage location (0.0-1.0) to a scale of 0.0-255. Make sure we don't have numbers outside of these ranges. 
				var x:Int = Math.round(255 * Math.max(0, Math.min(opoint.x, 2828)) / (2828));
				var y:Int = Math.round(255 * Math.max(0, Math.min(opoint.y, 2828)) / (2828));
				
				if (x == 0 || y == 0) r = 0; //set radius to 0 if we are not on screen
				
				//Use a bit shift to place our locations in the proper locatons.
				var color = (b << 24) | (x << 16) | (y << 8) | r;
				
				//colordata holds the actual color of the light for blending. The alpha value here is unused, but could be used for something like the rate of the light fallout!
				var colorData = (255 << 24) | (lholder.lightColor[0] << 16) | (lholder.lightColor[1] << 8) | lholder.lightColor[2];
				
				
				pixels.setPixel32(i, 0, color);
				pixels.setPixel32(i, 1, colorData);
				
				//increment through to the next member of our flxgroup
				currentLightHolderIndex += 1;
				
				opoint.put();
			}
			
			
			
		}
		
		//The last two pixels are reserved for determining the background color of the lights - for a night scene, for instance, you would want 
		var r = Math.round(brightness * 255);
		var g = Math.round(brightness * 255);
		var b = Math.
		var light = (255 << 24) | (Math.round(brightness * 255) << 16) | (Math.round(brightness * 255) << 8) | (Math.round(brightness * 255));
		pixels.setPixel32(127, 0, light);
		pixels.setPixel32(127, 1, light);
		
		scale.x = 40.0;
		scale.y = 40.0;

		//graphic.destroy();
		//
		//stamp(sprite, Math.round(player.getCenterXY().x - this.x), Math.round(player.getCenterXY().y - this.y));
	}
	
}