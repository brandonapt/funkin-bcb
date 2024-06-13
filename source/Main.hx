package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import MemCount;
import openfl.Lib;
import openfl.display.FPS;
import flixel.FlxG;
import Alphabet;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	#if desktop	
	public var webmHandle:WebmHandler;
	#end
	public static var hasLoadedPolymod:Bool = false;

	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = TitleState;
	var zoom:Int = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.



	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState));

		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
		debugMark.alpha = 0.4;
		//add(debugMark);
		#end

		#if !mobile
		MainVariables.initSave();

		

		fpsCounter = new FPS(10, 3, 0xFFFFFF);

		addChild(fpsCounter);
		memoryCounter = new MemoryCounter(10, 3, 0xffffff);
			
		addChild(memoryCounter);
		#end
	}

	public static function dumpCache()
		{
		// THIS IS FROM KADE ENGINE. THIS IS ALSO VERY POG
			@:privateAccess
			for (key in FlxG.bitmap._cache.keys())
			{
				var obj = FlxG.bitmap._cache.get(key);
				if (obj != null)
				{
					Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
				}
			}
			Assets.cache.clear("songs");
			
		}
	
	public function getFPS():Float
		{
			return fpsCounter.currentFPS;
		}
	public static var memoryCounter:MemoryCounter;

	public static function toggleMem(memEnabled:Bool):Void
	{
		memoryCounter.visible = memEnabled;
	}

	public static var fpsCounter:FPS;

	public static function toggleFPS(fpsEnabled:Bool):Void
	{
		fpsCounter.visible = fpsEnabled;
	}

	public function setFPSCap(cap:Float)
		{
			openfl.Lib.current.stage.frameRate = cap;
		}
}
