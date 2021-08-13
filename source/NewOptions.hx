package;
import flixel.addons.plugin.taskManager.FlxTaskManager;
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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Option;
import flixel.util.FlxColor;
import openfl.display.StageDisplayState;
import openfl.Lib;

class OptionsMenuSubState extends MusicBeatState
{
    var magenta:FlxSprite;
    var curSelected:Int = 0;
    public static var instance:OptionsMenuSubState;
        


        var options:Array<OptionCategory> = [
            new OptionCategory("Main Menu", [
                new EnableStoryMode('Toggles the story mode button.'),
                new EnableFreeplay('Toggles the freeplay button.'),
                new Watermarks('Toggles watermarks.')
            ]),
            new OptionCategory("Gameplay", [
                new HarderMode('Makes Hard Mode Even HARDER!'),
                new SongBar('Toggles a bar with the song progress.'),
                new GhostTaps('Toggles ghost tapping.'),
                new Autoplay('Toggles an autoplaying bot.'),
                new MissSFX('Toggles miss sound effects.'),
                new Input('Toggles the old and new input.'),
                new MissShake('Toggles screen shake on miss.'),
                new MissCry('Toggles GF\'s tears on miss.')
            ]),
            new OptionCategory("Freeplay", [
                new FreeplayPreviews('Toggles the song previews in freeplay.'),
                new FreeplayDialogue('Dialogue in Freeplay.'),
                new FreeplayIcons('Toggles the freeplay Icons.'),
                new FPBG('Toggles Freeplay Background Changes.')
            ]),
            new OptionCategory("Appearance", [
                new CustomIntro('Toggles a custom intro text set.'),
                new FpsCounter('Toggles a FPS Counter.'),
                new LogoAnimation('Toggles a cool animation on the title screen.'),
                new MemCounter('Toggles a Memory Counter.'),
                new NoteSplash('Toggles note splashes on SICK!'),
                //new IconZoom('Change the zoom on icons. (PRESS TO RESET)'),
                new P2Strums('Toggles the opponents notes lighting up.'),
              //  new FpsCap('Change your FPS Cap.')
            ]),
            new OptionCategory("Other", [
                new Changelog('View the latest Changelog.'),
                new Fullscreen('Toggle fullscreen.'),
                new ModManager('Open the in-game mod manager.')
            ])
            
        ];

        public var acceptInput:Bool = true;

        private var currentDescription:String = "";
        private var grpControls:FlxTypedGroup<Alphabet>;
        public static var versionShit:FlxText;
    
        var currentSelectedCat:OptionCategory;
        var blackBorder:FlxSprite;
        override function create()
            {

                FlxG.sound.playMusic(Paths.music('title'));
                instance = this;
                #if debug
                var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
                debugMark.alpha = 0.4;
                add(debugMark);
                #end
                magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
                magenta.scrollFactor.x = 0;
                magenta.scrollFactor.y = 0.18;
                magenta.setGraphicSize(Std.int(magenta.width * 1.1));
                magenta.updateHitbox();
                magenta.screenCenter();
                magenta.antialiasing = true;
                magenta.color = 0xFDdF819b;
                add(magenta);

                grpControls = new FlxTypedGroup<Alphabet>();
                add(grpControls);
        
                for (i in 0...options.length)
                {
                    var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
                    controlLabel.isMenuItem = true;
                    controlLabel.targetY = i;
                    grpControls.add(controlLabel);
                    // DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
                }

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

                super.create();
            }

            var isCatagory:Bool = false;

            override function update(elapsed:Float)
                {
                    super.update(elapsed);
            
                    if (acceptInput)
                    {
                        if (controls.BACK && !isCatagory)
                            {
                            FlxG.switchState(new MainMenuState());
                            FlxG.sound.playMusic(Paths.music('freakyMenu'));
                            }
                        else if (controls.BACK)
                        {
                            isCatagory = false;
                            grpControls.clear();
                            for (i in 0...options.length)
                            {
                                var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
                                controlLabel.isMenuItem = true;
                                controlLabel.targetY = i;
                                grpControls.add(controlLabel);
                                // DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
                            }
                            
                            curSelected = 0;
                            
                            changeSelection(curSelected);
                        }
            
                        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
            
                        if (FlxG.keys.justPressed.UP)
                            changeSelection(-1);
                        if (FlxG.keys.justPressed.DOWN)
                            changeSelection(1);
                        
                        if (isCatagory)
                        {
                            if (currentSelectedCat.getOptions()[curSelected].getAccept())
                            {
                                if (FlxG.keys.pressed.SHIFT)
                                    {
                                        if (FlxG.keys.pressed.RIGHT)
                                            currentSelectedCat.getOptions()[curSelected].right();
                                        if (FlxG.keys.pressed.LEFT)
                                            currentSelectedCat.getOptions()[curSelected].left();
                                    }
                                else
                                {
                                    if (FlxG.keys.justPressed.RIGHT)
                                        currentSelectedCat.getOptions()[curSelected].right();
                                    if (FlxG.keys.justPressed.LEFT)
                                        currentSelectedCat.getOptions()[curSelected].left();
                                }
                            }
                            if (currentSelectedCat.getOptions()[curSelected].getAccept())
                                versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
                            else
                            {
                                if (FlxG.keys.pressed.SHIFT)
                                {
                                    if (FlxG.keys.justPressed.RIGHT)
                                        currentSelectedCat.getOptions()[curSelected].right();
                                    else if (FlxG.keys.justPressed.LEFT)
                                        currentSelectedCat.getOptions()[curSelected].left();
                                }
                                else if (FlxG.keys.pressed.RIGHT)
                                    currentSelectedCat.getOptions()[curSelected].right();
                                else if (FlxG.keys.pressed.LEFT)
                                    currentSelectedCat.getOptions()[curSelected].left();
                                
                                versionShit.text = currentDescription;
                            }
                            if (currentSelectedCat.getOptions()[curSelected].getAccept())
                                versionShit.text = currentDescription;
                            else
                                versionShit.text = currentDescription;
                        }
                        else
                        {
                           
                            versionShit.text = currentDescription;
                        }
                    

            
                        if (controls.ACCEPT)
                        {
                            if (isCatagory)
                            {
                                if (currentSelectedCat.getOptions()[curSelected].press()) {
                                    grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
                                    trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
                                }
                            }
                            else
                            {
                                currentSelectedCat = options[curSelected];
                                isCatagory = true;
                                grpControls.clear();
                                for (i in 0...currentSelectedCat.getOptions().length)
                                    {
                                        var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
                                        controlLabel.isMenuItem = true;
                                        controlLabel.targetY = i;
                                        grpControls.add(controlLabel);
                                        // DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
                                    }
                                curSelected = 0;
                            }
                            
                            changeSelection();
                        }
                    }
                    FlxG.save.flush();
                }


                var isSettingControl:Bool = false;

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
                
                        if (isCatagory)
                            currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
                        else
                            currentDescription = "Please select a category";
                        if (isCatagory)
                        {
                            if (currentSelectedCat.getOptions()[curSelected].getAccept())
                                versionShit.text = currentDescription;
                            else
                                versionShit.text = currentDescription;
                        }
                        else
                            versionShit.text = currentDescription;
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
