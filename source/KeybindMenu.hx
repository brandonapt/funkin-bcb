package;

import NewOptions.OptionsMenuSubState;
#if desktop
import Discord.DiscordClient;
#end
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.macros.FlxMacroUtil;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;

class KeybindMenu extends MusicBeatState
{
	var selector:FlxText;

	public static var curSelected:Int = 0;

	var control:Array<String> = [];
	var whytho:Array<String> = [
		"UP", "DOWN", "LEFT", "RIGHT", "ACCEPT", "RESET", "BACK", "CHEAT"
	];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var changingInput:Bool = false;

	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('menuBGBlue'));

	var selectable:Bool = false;

	override function create()
	{
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);






		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				selectable = true;
			});
		

		control = CoolUtil.coolTextFile(Paths.txt('defaultControls'));

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		var i = 0;

		var elements:Array<String> = control[i].split(',');

		for (i in 0...whytho.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, '+' + whytho[i] + ': ' + Controls.keyboardMap.get(whytho[i]), true, false);
			controlLabel.targetY = i;
            controlLabel.isMenuItem = true;
			grpControls.add(controlLabel);
		}

	
		changeSelection();

		

		super.create();

	}

	override function update(elapsed:Float)
	{


		super.update(elapsed);

		if (!changingInput && selectable)
		{
			if (controls.BACK)
			{
				FlxG.switchState(new OptionsMenuSubState());
				Controls.saveControls();
				controls.setKeyboardScheme(Solo, true);
				selectable = false;

				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.ACCEPT)
			{
				if (!changingInput)
					FlxG.sound.play(Paths.sound('confirmMenu'));
				
				ChangeInput();
			}
		}
		else
		{
			ChangingInput();
		}
	}

	function changeSelection(change:Int = 0):Void
        {
            curSelected += change;
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    
            if (curSelected < 0)
                curSelected = whytho.length - 1;
            if (curSelected >= whytho.length)
                curSelected = 0;
    
            var bullShit:Int = 0;
    
            for (item in grpControls.members)
            {
                item.targetY = bullShit - curSelected;
                bullShit++;
    
                item.alpha = 0.6;
                // item.setGraphicSize(Std.int(item.width * 0.8));
    
                if (item.targetY == 0)
                {
                    item.alpha = 1;
                    // item.setGraphicSize(Std.int(item.width));
                }
            }
        }
	function ChangeInput()
	{
		changingInput = true;
		FlxFlicker.flicker(grpControls.members[curSelected], 0);
	}

	function ChangingInput()
	{
		if (FlxG.keys.pressed.ANY)
		{

			// Checks all known keys
			var keyMaps:Map<String, FlxKey> = FlxMacroUtil.buildMap("flixel.input.keyboard.FlxKey");
			for (key in keyMaps.keys())
			{
				if (FlxG.keys.checkStatus(key, 2) && key != "ANY")
				{
					FlxFlicker.stopFlickering(grpControls.members[curSelected]);

					var elements:Array<String> = grpControls.members[curSelected].text.split(':');
					var name:String = StringTools.replace(elements[0], '+', '');
                    grpControls.members[curSelected].reType('+' + name + ': ' + key);
					//var controlLabel:Alphabet = new Alphabet(0, 0, '+' + name + ': ' + key, true, false);
					//controlLabel.targetY = 0;


					//grpControls.replace(grpControls.members[curSelected], controlLabel);
					changingInput = false;

					Controls.keyboardMap.set(name, keyMaps[key]);
					FlxG.log.add(name + " is bound to " + keyMaps[key]);

					break;
				}
			}
		}
	}
}