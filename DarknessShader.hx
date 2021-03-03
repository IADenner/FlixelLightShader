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
			vec4 lightness;
			lightness = texture2D(sourceList, vec2(0.995, 0.25));
			for (float iterator = 0.0; iterator < 127.0; ++iterator)
			{
				//get the point on our texture where 
				vec2 sampleCoord = vec2(iterator/127.0, 0.25);
				vec4 value = texture2D(sourceList, sampleCoord);
				vec2 lightCoord = value.xy;
				float dist = distance(lightCoord, openfl_TextureCoordv);
				if (dist < value.z)
				{
	vec4 colorValue = texture2D(sourceList, vec2(iterator / 127.0, 0.75));
					lightness.x += (1.0 - dist * dist / (value.z * value.z)) * colorValue.x;
					lightness.y += (1.0 - dist * dist / (value.z * value.z)) * colorValue.y;
					lightness.z += (1.0 - dist*dist / (value.z * value.z)) * colorValue.z;
				}
			}
			
			vec4 thisAlpha;
			thisAlpha.x = max(0.0, min(1.0, lightness.x));
			thisAlpha.y = max(0.0, min(1.0, lightness.y));
			thisAlpha.z = max(0.0, min(1.0, lightness.z));
			
			vec4 baseColor = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(baseColor.x*thisAlpha.x, baseColor.y*thisAlpha.y, baseColor.z*thisAlpha.z, 1.0); //square our blues for blue tinge for now
			
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