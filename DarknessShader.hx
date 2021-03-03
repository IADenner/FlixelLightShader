package shaders.darknessPrototypes;
import flash.display.BitmapData;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxShader;
import gameTools.MyCamera;
import gameTools.PlayState;
import openfl.display.ShaderInput;

/**
 * ...
 * @author Isaac
 */
class DarknessShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header
		uniform sampler2D sourceList;
		void main()
		{
			//this is the variable we will be MULTIPLYING our canvas colros by
			vec4 lightness;
			
			//We grab our base value off of the last pixel of our darknessData bitmap. This is set in the last few lines of DarknessData's update function. This will be the color anything not lit will be
			//multiplied by. 
			lightness = texture2D(sourceList, vec2(0.995, 0.25));
			
			//iterate through the bitmap horizontally.
			for (float iterator = 0.0; iterator < 127.0; ++iterator)
			{
				//get the point on our texture where we will sample.
				vec2 sampleCoord = vec2(iterator / 127.0, 0.25);
				
				//this is the xy + brightness/radius data
				vec4 value = texture2D(sourceList, sampleCoord);
				
				//grab just the xy and calculate the distance. 
				vec2 lightCoord = value.xy;
				float dist = distance(lightCoord, openfl_TextureCoordv);
				if (dist < value.z)
				{
					//If you want to create different 'shapes' of lights, here's where you can do it. I wanted my lights to have a squared shape falloff, so I take lightness = (dist/brightness)^2
					//You could change this up so you have a flat falloff lightness = (dist/brightness), or a super sharp falloff (lightness = 1)
					vec4 colorValue = texture2D(sourceList, vec2(iterator / 127.0, 0.75));
					lightness.x += (1.0 - dist * dist / (value.z * value.z)) * colorValue.x;
					lightness.y += (1.0 - dist * dist / (value.z * value.z)) * colorValue.y;
					lightness.z += (1.0 - dist*dist / (value.z * value.z)) * colorValue.z;
				}
			}
			
			
			//clamp all of our values
			vec4 thisAlpha;
			thisAlpha.x = max(0.0, min(1.0, lightness.x));
			thisAlpha.y = max(0.0, min(1.0, lightness.y));
			thisAlpha.z = max(0.0, min(1.0, lightness.z));
			
			//now grab our canvas and multiply everything! Tada, we're done!
			vec4 baseColor = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(baseColor.x*thisAlpha.x, baseColor.y*thisAlpha.y, baseColor.z*thisAlpha.z, 1.0);
			
		}
		
	')
	
	var darknessData:DarknessData;
	public var light:Float = 1.0;
	public function new(tCamera:MyCamera) 
	{
		super();
		//
		//data.sourceList = new ShaderInput<BitmapData>();
		
		darknessData = new DarknessData(tCamera);
		PlayState.superforeground.add(darknessData);
		
		
	}
	
	public function update(ang:Float)
	{
		data.sourceList.input = darknessData.graphic.bitmap;
		//darknessData.setPosition(cPoint.x, cPoint.y);
		darknessData.angle = ang;
		darknessData.brightness = light;
	}
	
}