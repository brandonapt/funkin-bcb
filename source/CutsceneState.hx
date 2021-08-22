package;
import PlayState;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.app.Application;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

using StringTools;

class CutsceneState extends MusicBeatState
{

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	var startTimer:FlxTimer;

    private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;
    private var camGame:FlxCamera;
    var defaultCamZoom:Float = 1.05;

    var gfVersion:String = 'gf';


    override public function create()
    {

		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
		debugMark.alpha = 0.4;
		add(debugMark);
		#end
        PlayState.camHUD.visible = false;
        camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];

        switch (PlayState.Stage.curStage)
        {
            case 'stage':
                defaultCamZoom = 0.9;
                var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.9, 0.9);
                bg.active = false;
                add(bg);

                var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
                stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
                stageFront.updateHitbox();
                stageFront.antialiasing = true;
                stageFront.scrollFactor.set(0.9, 0.9);
                stageFront.active = false;
                add(stageFront);

                var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
                stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
                stageCurtains.updateHitbox();
                stageCurtains.antialiasing = true;
                stageCurtains.scrollFactor.set(1.3, 1.3);
                stageCurtains.active = false;

                add(stageCurtains);
        }

        gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, PlayState.SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
        //PlayState.boyfriend.animation.play('attack');

        switch (PlayState.SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (PlayState.isStoryMode)
				{
					camPos.x += 600;
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, PlayState.SONG.player1);

        switch (PlayState.Stage.curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);
        
		add(dad);
		add(boyfriend);

        camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

        startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
            {
                dad.dance();
                gf.dance();
				boyfriend.playAnim('idle');
            }, 0);

        super.create();
    }

    override public function update(elapsed:Float)
        {

            super.update(elapsed);

            if (FlxG.keys.pressed.H)
                {
                    boyfriend.playAnim('hey', true);
                }
			if (FlxG.keys.pressed.E)
				{
					gf.playAnim('cheer');
				}

				
                    


            
            
        }
}