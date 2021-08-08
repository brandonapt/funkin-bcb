package;
import polymod.Polymod;
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
    public static var enabledMods:Array<String>;



    public static var versionShit:FlxText;
    var currentDescription:String = "";
    var blackBorder:FlxSprite;




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

            if (FlxG.save.data.EnabledMods != null)
               enabledMods = FlxG.save.data.EnabledMods;

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
            enabledMods = modList;

            currentDescription = "none";

            versionShit = new FlxText(5, FlxG.height + 40, 0, currentDescription, 12);
            versionShit.scrollFactor.set();
            versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                
            blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(versionShit.width + 900)),Std.int(versionShit.height + 600),FlxColor.BLACK);
            blackBorder.alpha = 0.5;
        
            add(blackBorder);
        
            add(versionShit);
        
            FlxTween.tween(versionShit,{y: FlxG.height - 18},2,{ease: FlxEase.expoInOut});
            FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.expoInOut});
            changeSelection();
        }
    
    override function update(elapsed:Float)
        {
            super.update(elapsed);
            FlxG.save.data.EnabledMods = enabledMods;
            enabledMods = FlxG.save.data.EnabledMods;
            versionShit.text = currentDescription;
            var accepted = controls.ACCEPT;
            if (accepted)
                {
                    //trace(modList[curSelected]);
                    if (grpControls.members[curSelected].text == modList[curSelected])
                    {
                        trace(modList[curSelected]);
                        enabledMods.remove(modList[curSelected]);
                        grpControls.members[curSelected].reType(modList[curSelected] + "- DISABLED");
                    } else {
                        trace(modList[curSelected]);
                        enabledMods.push(modList[curSelected]);
                        grpControls.members[curSelected].reType(modList[curSelected]);

                    }
                    //FlxG.save.data.modList[curSelected] = !FlxG.save.data.modList[curSelected];
                    
                }

            if (controls.BACK)
            {
                FlxG.switchState(new OptionsMenuSubState());
                polymod.Polymod.init({
                    modRoot:"mods/",
                    dirs:enabledMods
                });
                FlxG.save.flush();
            }


            if (FlxG.keys.justPressed.UP)
                changeSelection(1); 
            if (FlxG.keys.justPressed.DOWN)
                changeSelection(-1);
        }

        function changeSelection(change:Int = 0)
            {
                #if !switch
                // NGio.logEvent("Fresh");
                #end
                
                FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
        
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