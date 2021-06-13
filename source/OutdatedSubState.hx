package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "kjNKFJNKJNS LOL";
	public static var currChanges:String = "ef";
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

	override function create()
	{
		super.create();


		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Your BCB Engine is outdated!\nYou are on "
			+ Application.current.meta.get('version')
			+ "\nwhile the most recent version is " + needVer + "."
			+ "\n\nWhat's new:\n\n"
			+ currChanges
			+ "\n& more changes and bugfixes in the full changelog"
			+ "\n\nPress Space to view the full changelog and update\nor ESCAPE to ignore this",
			32);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
		
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
		}, 0);
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
		}, 0);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			#if linux
			Sys.command('/usr/bin/xdg-open', ["https://github.com/brandoge91/funkin-bcb", "&"]);
			#else
			FlxG.openURL('https://github.com/brandoge91/funkin-bcb');
			#end
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
