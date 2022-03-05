package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;

using StringTools;

class DialogueFunctions
{
    var song = PlayState.SONG.song.toLowerCase();
    
    public function cameraFlash(color:FlxColor, duration:Float)
        {
            trace('camera flash: ' + song + color + duration);
            FlxG.camera.flash(color, duration);
        }

    public static function screenShake(intensity:Int, duration:Float)
        {
            PlayState.camGame.shake(intensity,duration,null,true);
        }
    
    public function playSound(name:String, volume:Float)
    {
        FlxG.sound.play(Paths.sound(name), volume);
    }

    public function playPortAnim(port:FlxSprite, name:String, ?forced:Bool = true)
    {
        port.animation.play(name);
    }
}