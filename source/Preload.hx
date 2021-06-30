package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import Controls.Control;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class PreloadingState extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;
    public static var isItDone:Bool = false;
    var skippedLol:Bool = false;

    var text:FlxText;
    var pressEnter:FlxText;
    var logoBl:FlxSprite;

	override function create()
	{





        logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.screenCenter(X);
        logoBl.screenCenter(Y);



        pressEnter = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Press Enter to Skip Initialization");
        pressEnter.size = 20;
        pressEnter.alpha = 1;
        pressEnter.y = 95;
        pressEnter.updateHitbox();
        pressEnter.screenCenter(X);

        text = new FlxText(-150 / 2, FlxG.height / 2 + 300,0,"Loading Assets...");
        text.size = 34;
        text.alpha = 1;
        text.y = 50;
        text.x = pressEnter.x - 25;

        add(text);
        add(pressEnter);
        add(logoBl);
        
        sys.thread.Thread.create(() -> {
            cache();
        });


        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {

        var accepted = controls.ACCEPT;

        if (toBeDone != 0 && done != toBeDone)
        {
            text.text = "Preloading Assets - " + done + "/" + toBeDone + "";
        }

        if (accepted)
        {
            isItDone = true;
            skippedLol = true;
            FlxG.switchState(new TitleState());
        }

        super.update(elapsed);
    }


    function cache()
    {

        var images = [];
        var music = [];
        //CHART PRELOADING IS COMING SOON. SOME OTHER STUFF ASWELL
        var others = [];
        var data = [];


        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/peoples")))
        {
            if (!i.endsWith(".png"))
                continue;
            images.push(i);
        }



        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }
        toBeDone = Lambda.count(images) + Lambda.count(music);

        for (i in music)
            {
                FlxG.sound.cache(Paths.inst(i));
                FlxG.sound.cache(Paths.voices(i));
                done++;
            }

        for (i in images)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("peoples/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        isItDone = true;
        if (skippedLol == false) {
            FlxG.switchState(new TitleState());
        }
    }

}

