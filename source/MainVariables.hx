import openfl.Lib;
import flixel.FlxG;

class MainVariables
{
    public static function initSave()
    {
        if (FlxG.save.data.harderMode == null)
			FlxG.save.data.harderMode = false;
        if (FlxG.save.data.customIntroText == null)
            FlxG.save.data.customIntroText = true;
        if (FlxG.save.data.movingLogo == null)
            FlxG.save.data.movingLogo = true;
        if (FlxG.save.data.playDialogue == null)
            FlxG.save.data.playDialogue = true;
        if (FlxG.save.data.playSongs == null)
            FlxG.save.data.playSongs = false;
        if (FlxG.save.data.songPosition == null)
            FlxG.save.data.songPosition = false;
        if (FlxG.save.data.autoplay == null)
            FlxG.save.data.autoplay = false;
        if (FlxG.save.data.ghosttaps == null)
            FlxG.save.data.ghosttaps = true;
        if (FlxG.save.data.fullscreen == null)
            FlxG.save.data.fullscreen = false;
        if (FlxG.save.data.freeplayIcons == null)
            FlxG.save.data.freeplayIcons = true;
        if (FlxG.save.data.fpsCounter == null)
            FlxG.save.data.fpsCounter = true;
        if (FlxG.save.data.memCounter == null)
            FlxG.save.data.memCounter = false;
        if (FlxG.save.data.fpbg == null)
            FlxG.save.data.fpbg = true; 
        if (FlxG.save.data.missSfx == null)
            FlxG.save.data.missSfx = true;
        if (FlxG.save.data.autoplay == null)
            FlxG.save.data.autoplay = false;
        if (FlxG.save.data.loadChars == null)
            FlxG.save.data.loadChars = true;
        if (FlxG.save.data.loadSongs == null)
            FlxG.save.data.loadSongs = true;
        if (FlxG.save.data.loadGraphics == null)
            FlxG.save.data.loadGraphics = true;
        if (FlxG.save.data.newInput == null)
            FlxG.save.data.newInput = false;


	}
}