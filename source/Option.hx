package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;
import openfl.display.StageDisplayState;



class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String { return throw "stub!"; };
	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}

class Changelog extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new ChangelogState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "View the Changelog";
	}
}

class HarderMode extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.harderMode = !FlxG.save.data.harderMode;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.harderMode ? "Harder Hard Mode On" : "Harder Hard Mode Off";
	}

}

class LogoAnimation extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.movingLogo = !FlxG.save.data.movingLogo;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.movingLogo ? "Moving Title Logo" : "Static Title Logo";
	}
}

	class CustomIntro extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.customIntroText = !FlxG.save.data.customIntroText;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.customIntroText ? "Custom Intro Text" : "Default Intro Text";
	}


}

class FreeplayPreviews extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.playSongs = !FlxG.save.data.playSongs;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.playSongs ? "Freeplay Song Previews" : "No Freeplay Song Previews";
	}
}

class FreeplayDialogue extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.playDialogue = !FlxG.save.data.playDialogue;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.playDialogue ? "Freeplay Dialogue" : "No Freeplay Dialogue";
	}
}

class SongBar extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.songPosition ? "Progress Bar" : "No Progress Bar";
	}
}

class GhostTaps extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.ghosttaps = !FlxG.save.data.ghosttaps;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.ghosttaps ? "Ghost Tapping" : "No Ghost Tapping";
	}
}



class Fullscreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		function toggleFullscreen() {

            if(Lib.current.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE){
        
                Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        
            }else {
        
                Lib.current.stage.displayState = StageDisplayState.NORMAL;
        
            }
        
        }
		toggleFullscreen();
		FlxG.save.data.fullscreen = !FlxG.save.data.fullscreen;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.fullscreen ? "Fullscreen On" : "Fullscreen Off";
	}
}

class FreeplayIcons extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.freeplayIcons = !FlxG.save.data.freeplayIcons;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.freeplayIcons ? "Freeplay icons on" : "Freeplay icons off";
	}
}

class FpsCounter extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsCounter = !FlxG.save.data.fpsCounter;

		Main.toggleFPS(FlxG.save.data.fpsCounter);
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.fpsCounter ? "FPS Counter" : "No FPS Counter";
	}
}

class MemCounter extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.memCounter = !FlxG.save.data.memCounter;

		Main.toggleMem(FlxG.save.data.memCounter);
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.memCounter ? "Memory Counter" : "No Memory Counter";
	}
}

class FPBG extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpbg = !FlxG.save.data.fpbg;

		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.fpbg ? "Freeplay BG Color changes" : "freeplay bg color static";
	}
}

class Autoplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.autoplay = !FlxG.save.data.autoplay;

		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.autoplay ? "Autoplay on" : "Autoplay off";
	}
}

class MissSFX extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.missSfx = !FlxG.save.data.missSfx;

		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.missSfx ? "miss sfx on" : "miss sfx off";
	}
}


class PreloadMusic extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.loadSongs = !FlxG.save.data.loadSongs;

		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.loadSongs ? "dont preload songs" : "preload songs";
	}
}

class PreloadChars extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.loadChars = !FlxG.save.data.loadChars;

		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.loadChars ? "dont preload characters" : "preload characters";
	}
}

class PreloadGraphics extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.loadGraphics = !FlxG.save.data.loadGraphics;

		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.loadGraphics ? "dont preload graphics" : "preload graphics";
	}
}
