package;
import haxe.macro.CompilationServer.ModuleCheckPolicy;
import Controls.Control;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxSave;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import Controls.Control;
import Controls.KeyboardScheme;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import haxe.Json;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import NewOptions;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.display.StageDisplayState;
import openfl.Lib;

class ModManagerState extends MusicBeatState
{
    var magenta:FlxSprite;
    private var grpControls:FlxTypedGroup<Alphabet>;
    var modList = CoolUtil.coolTextFile(Paths.txt('modList'));
    var curSelected:Int = 0;



    override function create()
        {
            magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
            magenta.scrollFactor.x = 0;
            magenta.scrollFactor.y = 0.18;
            magenta.setGraphicSize(Std.int(magenta.width * 1.1));
            magenta.updateHitbox();
            magenta.screenCenter();
            magenta.antialiasing = true;
            magenta.color = 0xFFdf718b;
            add(magenta);

            grpControls = new FlxTypedGroup<Alphabet>();
            add(grpControls);

            for (i in 0...modList.length)
                {
                    var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, modList[i], true, false, true);
                    controlLabel.isMenuItem = true;
                    controlLabel.targetY = i;
                    grpControls.add(controlLabel);

        
                    // DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
                }
            changeSelection();
        }
    
    override function update(elapsed:Float)
        {
            super.update(elapsed);

            var accepted = controls.ACCEPT;
            if (accepted)
                {
                    //trace(modList[curSelected]);
                    var po:String = modList[curSelected];
                    if (FlxG.save.data.po == null)
                        FlxG.save.data.po == true;
                    //FlxG.save.data.modList[curSelected] = !FlxG.save.data.modList[curSelected];
                    
                }

            if (controls.BACK)
                FlxG.switchState(new OptionsMenuSubState());
                FlxG.save.flush();


            if (FlxG.keys.justPressed.UP)
                changeSelection(-1);
            if (FlxG.keys.justPressed.DOWN)
                changeSelection(1);
        }

        function changeSelection(change:Int = 0)
            {
                #if !switch
                // NGio.logEvent("Fresh");
                #end
                
                FlxG.sound.play(Paths.sound("scrollMenu"), 0.7);
        
                curSelected += change;
        
                if (curSelected < 0)
                    curSelected = grpControls.length - 1;
                if (curSelected >= grpControls.length)
                    curSelected = 0;
                // selector.y = (70 * curSelected) + 30;
        
                var bullShit:Int = 0;
        
                for (item in grpControls.members)
                {
                    item.targetY = bullShit - curSelected;
                    bullShit++;
        
                    item.alpha = 0.64;
                    // item.setGraphicSize(Std.int(item.width * 0.8));
        
                    if (item.targetY == 0)
                    {
                        item.alpha = 1;
                        // item.setGraphicSize(Std.int(item.width));
                    }
                }
            }
}