#if desktop
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import sys.FileSystem;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Startup extends MusicBeatState
{

    //var dummy:FlxSprite;
    public static var isItDone:Bool = false;
    var loadingText:FlxText;

    var songsCached:Bool = FlxG.save.data.loadSongs;
    var music = [];
                                
    //List of character graphics and some other stuff.
    //Just in case it want to do something with it later.
    var charactersCached:Bool = FlxG.save.data.loadChars;
    var characters:Array<String> =   ["peoples/BOYFRIEND", "bfCar", "christmas/bfChristmas", "weeb/bfPixel", "weeb/bfPixelsDEAD",
                                    "peoples/GF_assets", "gfCar", "christmas/gfChristmas", "weeb/gfPixel",
                                    "peoples/DADDY_DEAREST", "peoples/spooky_kids_assets", "peoples/Monster_Assets",
                                    "Pico_FNF_assetss", "Mom_Assets", "momCar",
                                    "christmas/mom_dad_christmas_assets", "christmas/monsterChristmas",
                                    "weeb/senpai", "weeb/spirit", "weeb/senpaiCrazy"];

    var graphicsCached:Bool = FlxG.save.data.loadGraphics;
    var graphics:Array<String> =    ["logoBumpin", "gfDanceTitle", "titleEnter",
                                    "stageback", "stagefront", "stagecurtains",
                                    "halloween_bg",
                                    "philly/sky", "philly/city", "philly/behindTrain", "philly/train", "philly/street", "philly/win0", "philly/win1", "philly/win2", "philly/win3", "philly/win4",
                                    "limo/bgLimo", "limo/fastCarLol", "limo/limoDancer", "limo/limoDrive", "limo/limoSunset",
                                    "christmas/bgWalls", "christmas/upperBop", "christmas/bgEscalator", "christmas/christmasTree", "christmas/bottomBop", "christmas/fgSnow", "christmas/santa",
                                    "christmas/evilBG", "christmas/evilTree", "christmas/evilSnow",
                                    "weeb/weebSky", "weeb/weebSchool", "weeb/weebStreet", "weeb/weebTreesBack", "weeb/weebTrees", "weeb/petals", "weeb/bgFreaks",
                                    "weeb/animatedEvilSchool"];

    var cacheStart:Bool = false;

	override function create()
	{


        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
            {
                music.push(i);
            }
        FlxG.mouse.visible = false;
        FlxG.sound.muteKeys = null;

        loadingText = new FlxText(5, FlxG.height - 30, 0, "", 24);
        loadingText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loadingText);

        new FlxTimer().start(1.1, function(tmr:FlxTimer)
        {
        });
        
        super.create();

    }

    override function update(elapsed) 
    {
        
        if(!cacheStart){
            preload(); 
            cacheStart = true;
        }
        if(isItDone == true){
            FlxG.switchState(new TitleState());

            
        }

        if(songsCached && charactersCached && graphicsCached) {
            

            new FlxTimer().start(0.3, function(tmr:FlxTimer)
            {
                loadingText.text = "Done!";
                isItDone = true;
            });

            //FlxG.sound.play("assets/sounds/loadComplete.ogg");
        }
        
        super.update(elapsed);

    }

    function preload(){

        loadingText.text = "Preloading Assets...";

        if(!songsCached){
            sys.thread.Thread.create(() -> {
                preloadMusic();
            });
        }

        if(!charactersCached){
            sys.thread.Thread.create(() -> {
                preloadCharacters();
            });
        }

        if(!graphicsCached){
            sys.thread.Thread.create(() -> {
                preloadGraphics();
            });
        }

    }

    function preloadMusic(){
        for (i in music)
            {
                FlxG.sound.cache(Paths.inst(i));
                FlxG.sound.cache(Paths.voices(i));
                trace(i);
            }
            songsCached = true;

    }

    function preloadCharacters(){
        for(x in characters){
            ImageCache.add("assets/images/" + x + ".png");
            trace("Chached " + x);
        }
        charactersCached = true;
    }

    function preloadGraphics(){
        for(x in graphics){
            ImageCache.add("assets/images/" + x + ".png");
            trace("Chached " + x);
        }
        graphicsCached = true;
    }

}
#end