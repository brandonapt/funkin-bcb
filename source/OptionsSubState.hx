package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import lime.utils.Assets;


class OptionsSubState extends MusicBeatSubstate
{

    var options:Array<String> = [
        "Changelog",
        "POGGERs"
	];
    var curSelected:Int = 0;
    var upP = controls.UP_P;
    var downP = controls.DOWN_P;
    var accepted = controls.ACCEPT;
    var Catagories:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();




	public function new()
	{
		super();
        var controlLabel:Alphabet = new Alphabet(0, 30, "Options", true, false);
        controlLabel.screenCenter(X);
        var magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        magenta.scrollFactor.x = 0;
        magenta.scrollFactor.y = 0.18;
        magenta.setGraphicSize(Std.int(magenta.width * 1.1));
        magenta.updateHitbox();
        magenta.screenCenter();
        magenta.antialiasing = true;
        magenta.color = 0xFFfd719b;
        add(magenta);
        add(controlLabel);
        //var songText:Alphabet = new Alphabet();



	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        function changeSelection(change:Int = 0)
            {
                add(Catagories);
                #if !switch
                NGio.logEvent('Fresh');
                #end
            
                    // NGio.logEvent('Fresh');
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        
                curSelected += change;
            
                if (curSelected < 0)
                    curSelected = options.length - 1;
                if (curSelected >= options.length)
                    curSelected = 0;
            
                    // selector.y = (70 * curSelected) + 30;
            

            
                    var bullShit:Int = 0;
            
            
                    for (item in Catagories.members)
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



		if (upP)
            {
                changeSelection(-1);
            }
            if (downP)
            {
                changeSelection(1);
            }
        if (controls.BACK)
            {
                FlxG.switchState(new MainMenuState());
            }
        if (accepted)
            {
               
                   
            }
        
        
	}
}