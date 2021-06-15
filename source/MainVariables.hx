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

	}
}