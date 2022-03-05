package;

import EndScreenState.EndScreenSubstate;
#if desktop
import Discord.DiscordClient;
#end
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
#if sys
import sys.FileSystem;
#end
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

class PlayState extends MusicBeatState
{

	public static var SONG:SwagSong;

	var trackedAssets:Array<FlxBasic> = [];


	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public static var halloweenLevel:Bool = false;

	public static var carGf:Bool = true;
	private var camFocus:String = "";
	private var camTween:FlxTween;
	private var camFollow:FlxObject;
	private var autoCam:Bool = true;

	private var didChart = false;
	private var vocals:FlxSound;

	var skippedtime:Bool = false;
	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var autoplayText:FlxText;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var player2Strums:FlxTypedGroup<FlxSprite>;

	private var strums2:Array<Array<Bool>> = [[false, false], [false, false], [false, false], [false, false]];

	private var camZooming:Bool = false;
	public static var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;


	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public static var goods:Int;
	public static var sicks:Int;
	public static var shits:Int;
	public static var bads:Int;
	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;

	var dialogue:Array<String> = [];

 	public static var isHalloween:Bool = false;

 	public static var trainSound:FlxSound;


	public static var isBfOld:Bool = false;



	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public static var songMisses:Int = 0;
	public static var totalNotesHit:Float = 0;
	public static var accuracy:Float = 0.00;
	public static  var totalPlayed:Int = 0;
	private var ss:Bool = false;
	public static var songScore:Int = 0;
	var scoreTxt:FlxText;

	public static var campaignScore:Int = 0;

	public static var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	



	// Discord RPC variables
	public static var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	public static var Stage:Stage;
	var detailsPausedText:String = "";


	override public function create()
	{
		resetScore();		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",true,false,false);
		debugMark.alpha = 0.4;
		add(debugMark);
		#end
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = CoolUtil.coolTextFile(Paths.txt('tutorial/lol'));
			case 'bopeebo':
				dialogue = CoolUtil.coolTextFile(Paths.txt('bopeebo/dia'));
			//case 'fresh':
			//dialogue = CoolUtil.coolTextFile(Paths.txt('fresh/daa'));
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}
		
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}
		#if html5
		didChart = false;
		#else
		didChart = FileSystem.exists(Paths.lua(SONG.song.toLowerCase() + "/modchart"));
		#end
		#if desktop
		// Making difficulty text for Discord Rich Presence.


		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

	

		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf':
				gfVersion = 'gf';
			default:
				gfVersion = 'gf';
		}


		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		if (dad.frames == null)
			{
				#if debug
				FlxG.log.warn(["Couldn't load opponent: " + SONG.player2 + ". Loading default opponent"]);
				#end
				dad = new Character(100, 100, 'dad');
			}

			boyfriend = new Boyfriend(770, 450, SONG.player1);

			if (boyfriend.frames == null)
			{
				#if debug
				FlxG.log.warn(["Couldn't load boyfriend: " + SONG.player1 + ". Loading default boyfriend"]);
				#end
				boyfriend = new Boyfriend(770, 450, 'bf');
			}
	
				
			Stage = new Stage(SONG.stage);
			for (i in Stage.toAdd)
			{
				add(i);
			}
			for (index => array in Stage.layInFront)
			{
				switch (index)
				{
					case 0:
						add(gf);
						gf.scrollFactor.set(0.95, 0.95);
						for (bg in array)
							add(bg);
					case 1:
						add(dad);
						for (bg in array)
							add(bg);
					case 2:
						trace('poopy bf');
						add(boyfriend);
						for (bg in array)
							add(bg);
				}
			}
				
	
	

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (dad.curCharacter)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
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


		// REPOSITIONING PER STAGE
		switch (Stage.curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();

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

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll) {
			strumLine.y = FlxG.height - 165;
		}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		player2Strums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, TOPDOWN_TIGHT, 0.2);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition == true)
			{
				songPosBG = new FlxSprite(0, 4).loadGraphic(Paths.image('healthBar'));
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 3.5, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.BLUE);
				add(songPosBar);
	
			}


		healthBarBG = new FlxSprite(0, FlxG.height * 0.88).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll) {
			healthBarBG.y = 50;
		}
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'health', 0, 2);
	healthBar.scrollFactor.set();
	healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
	// healthBar
		add(healthBar);
		if (FlxG.save.data.middlescroll)
			scoreTxt = new FlxText(healthBarBG.x - 105, (FlxG.height * 0.9) + 36, 800, "", 22);
		else
			scoreTxt = new FlxText(healthBarBG.x - 105, healthBarBG.y + 50, 800, "", 22);
		//scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.screenCenter(X);
		if (!FlxG.save.data.autoplay)
			add(scoreTxt);

		autoplayText = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 40, healthBarBG.y + -100, 0, "AUTOPLAY ON", 20);
		autoplayText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		autoplayText.scrollFactor.set();

		if(FlxG.save.data.autoplay) add(autoplayText);

		// changes health icon if old bf is toggled 
		if (isBfOld)
			{
				iconP1 = new HealthIcon('bf-old', true);
			} else
			{
				iconP1 = new HealthIcon(boyfriend.curCharacter, true);
			}
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(dad.curCharacter, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
			{
				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
			}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode || FlxG.save.data.playDialogue == true)
			{
				switch (curSong.toLowerCase())
				{
					case "winter-horrorland":
						var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
						add(blackScreen);
						blackScreen.scrollFactor.set();
						camHUD.visible = false;
	
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							remove(blackScreen);
							FlxG.sound.play(Paths.sound('Lights_Turn_On'));
							camFollow.y = -2050;
							camFollow.x += 200;
							FlxG.camera.focusOn(camFollow.getPosition());
							FlxG.camera.zoom = 1.5;
	
							new FlxTimer().start(0.8, function(tmr:FlxTimer)
							{
								camHUD.visible = true;
								remove(blackScreen);
								FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
									ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										startCountdown();
									}
								});
							});
						});
					case 'senpai':
						schoolIntro(doof);
					case 'roses':
						FlxG.sound.play(Paths.sound('ANGRY'));
							schoolIntro(doof);
					case 'thorns':
							schoolIntro(doof);
				//	case 'tutorial':
						//	schoolIntro(doof);
					//case 'bopeebo':
						//schoolIntro(doof);
						//schoolIntro(doof);
					//case 'fresh':
					//	schoolIntro(doof);
					default:
						startCountdown();
				}
			}
			else
			{
				startCountdown();
			}

			
	
			super.create();
		}


	

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();


		var senpaiEvil:FlxSprite = new FlxSprite();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
			senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
			senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
			senpaiEvil.scrollFactor.set();
			senpaiEvil.updateHitbox();
			senpaiEvil.screenCenter();
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				camHUD.visible = false;
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									camHUD.visible = true;
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	#if sys
	public static var luaModchart:LuaState = null;
	#end
	

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);
		#if sys
		if (didChart)
			{
				luaModchart = LuaState.createModchartState();
				luaModchart.executeState('start', [SONG.song.toLowerCase()]);
			}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == Stage.curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					if (SONG.song.toLowerCase() == "senpai" || SONG.song.toLowerCase() == "roses" || SONG.song.toLowerCase() == "thorns")
						{
							FlxG.sound.play(Paths.sound('intro3-pixel'), 0.6);
						} else {
							FlxG.sound.play(Paths.sound('intro3'), 0.6);
						}
					case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (Stage.curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					if (SONG.song.toLowerCase() == "senpai" || SONG.song.toLowerCase() == "roses" || SONG.song.toLowerCase() == "thorns")
						{
							FlxG.sound.play(Paths.sound('intro2-pixel'), 0.6);
						} else {
							FlxG.sound.play(Paths.sound('intro2'), 0.6);
						}			
							case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (Stage.curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					if (SONG.song.toLowerCase() == "senpai" || SONG.song.toLowerCase() == "roses" || SONG.song.toLowerCase() == "thorns")
						{
							FlxG.sound.play(Paths.sound('intro1-pixel'), 0.6);
						} else {
							FlxG.sound.play(Paths.sound('intro1'), 0.6);
						}				
							case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (Stage.curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					if (SONG.song.toLowerCase() == "senpai" || SONG.song.toLowerCase() == "roses" || SONG.song.toLowerCase() == "thorns")
						{
							FlxG.sound.play(Paths.sound('introGo-pixel'), 0.6);
						} else {
							FlxG.sound.play(Paths.sound('introGo'), 0.6);
						}
							case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
			{
				remove(songPosBG);
				remove(songPosBar);
	
				songPosBG = new FlxSprite(0, 4).loadGraphic(Paths.image('healthBar'));
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
	
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, songLength - 1000);
				songPosBar.numDivisions = 1000;
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.WHITE);
				add(songPosBar);
	
				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
			}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;


				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.death = songNotes[3];
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
					}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			} else {
				player2Strums.add(babyArrow);
			}
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			
			if (FlxG.save.data.middlescroll) {
				babyArrow.x -= 275;
				if (player != 1) {
					babyArrow.visible = false;
				}
			}

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.TWO)
			{
				//endSong();
			}

		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE) 
		{
			if (iconP1.animation.curAnim.name != 'bf-old')
			{
				iconP1.animation.play('bf-old');
				isBfOld = !isBfOld;
				
			}
			else
			{
				iconP1.animation.play(SONG.player1);
			}

		}
		#if debug
		if (FlxG.keys.justPressed.V)
			{
				//FlxG.switchState(new VideoState('assets/videos/vid.webm', new TitleState(), -1, true));
			}
		#end

		switch (Stage.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
		}

		super.update(elapsed);

		accuracy = FlxMath.roundDecimal(totalNotesHit / (totalNotesHit + songMisses) * 100, 1);

		if (Math.isNaN(accuracy))
			{
				accuracy = 100;
			}

			var rating = "??"; // incase it doesnt load or start idk
				if (accuracy == 100)
				{
					rating = "SFC";
				}
				else if (accuracy > 90)
				{
					rating = "S";
				}
				else if (accuracy > 80)
				{
					rating = "A";
				}
				else if (accuracy > 70)
				{
					rating = "B";
				}
				else if (accuracy > 60)
				{
					rating = "C";
				}
				else if (accuracy > 50)
				{
					rating = "D";
				}
				else if (accuracy > 30)
				{
					rating = "E";
				}
				else
				{
					rating = "F";
				}

				
				if (songMisses == 0) {
					rating = rating + " (FC)";
				}
	

		scoreTxt.text = "Misses: " + songMisses + " | " + "Score: " + songScore + " | " + "Accuracy: " + accuracy + "% | " + rating;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			//openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			if (luaModchart != null)
				{
					luaModchart.die();
					luaModchart = null;
				}
			#end


		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, FlxG.save.data.iconZoom, 0.09 / (60 / 60))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, FlxG.save.data.iconZoom, 0.09 / (60 / 60))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));


		
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (Stage.curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			new FlxTimer().start(0.7);

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (FlxG.save.data.downscroll)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
						if(daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;

								if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
						}
					}else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
						if(daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

								if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
						}
					}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}

					player2Strums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								if (storyDifficulty == 2) {
									if (FlxG.save.data.harderMode == true) {
										health -= 0.0175;
									}
								}
								if (FlxG.save.data.player2Strums)
									{
								spr.animation.play('confirm', true);
								sustain2(spr.ID, daNote);
									}
							}
						});

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.mustPress)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote) {
						} else {
							daNote.x += 35;
						}
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote) {
						} else {
							daNote.x += 35;
						}
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (daNote.death == false) {
									health -= 0.075;

									if (!daNote.isSustainNote) {
										//songMisses++;
									}
									trace(daNote.death);
									vocals.volume = 0;
									noteMiss(daNote.noteData);
								}
							}

							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
			});
		}

		if (!inCutscene && !FlxG.save.data.autoplay)
			keyShit();
		else if (FlxG.save.data.autoplay)
			autoplayItLol();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}


	function sustain2(strum:Int, note:Note):Void
		{
			var length:Float = note.sustainLength;
	
			if (length > 0)
			{
				switch (strum)
				{
					case 0:
						strums2[0][0] = true;
					case 1:
						strums2[1][0] = true;
					case 2:
						strums2[2][0] = true;
					case 3:
						strums2[3][0] = true;
				}
			}
	
			var bps:Float = Conductor.bpm/60;
			var spb:Float = 1/bps;
	
			if (!note.isSustainNote)
			{
	
				new FlxTimer().start(length == 0 ? 0.2 : (length / Conductor.crochet * spb) + 0.1, function(tmr:FlxTimer)
				{
					switch (strum)
					{
						case 0:
							if (!strums2[0][0])
							{
								strums2[0][1] = true;
							} else if (length > 0) {
								strums2[0][0] = false;
								strums2[0][1] = true;
							}
						case 1:
							if (!strums2[1][0])
							{
								strums2[1][1] = true;
							} else if (length > 0) {
								strums2[1][0] = false;
								strums2[1][1] = true;
							}
						case 2:
							if (!strums2[2][0])
							{
								strums2[2][1] = true;
							} else if (length > 0) {
								strums2[2][0] = false;
								strums2[2][1] = true;
							}
						case 3:
							if (!strums2[3][0])
							{
								strums2[3][1] = true;
							} else if (length > 0) {
								strums2[3][0] = false;
								strums2[3][1] = true;
							}
					}
	
				});
			}
		}
	
		public static function resetScore()
			{
				//band aid fix becuase lol
				songMisses = 0;
				accuracy = 0;
				sicks = 0;
				goods = 0;
				shits = 0;
				bads = 0;
				songScore = 0;
				totalNotesHit = 0;
				totalPlayed = 0;
			}


		function endSong():Void
			{

				#if sys
				if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end
				//openSubState(new EndScreenSubstate(accuracy, totalNotesHit, songMisses, songMisses, shits, bads, goods, sicks, songScore, camHUD));
				trace(totalNotesHit);
				canPause = false;
				paused = true;
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				if (SONG.validScore)
				{
					#if !switch
					Highscore.saveScore(SONG.song, songScore, storyDifficulty);
					#end
				}

				resetScore();

		
				if (isStoryMode)
				{
					campaignScore += songScore;
		
					storyPlaylist.remove(storyPlaylist[0]);
		
					if (storyPlaylist.length <= 0)
					{
						if (FlxG.save.data.sussyBakka)
							FlxG.sound.playMusic(Paths.music('MenuMusicAlt'));
						else
							FlxG.sound.playMusic(Paths.music('freakyMenu'));		
						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;
						new FlxTimer().start(0.7);
						FlxG.switchState(new StoryMenuState());
						//openSubState(new ResultsSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
						// if ()
						StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
		

		
						FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
						FlxG.save.flush();
					}
					else
					{
						var difficulty:String = "";
		
						if (storyDifficulty == 0)
							difficulty = '-easy';
		
						if (storyDifficulty == 2)
							difficulty = '-hard';
		
						trace('LOADING NEXT SONG');
						trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
		
						if (SONG.song.toLowerCase() == 'eggnog')
						{
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							add(blackShit);
							camHUD.visible = false;
		
							FlxG.sound.play(Paths.sound('Lights_Shut_off'));
						}
		
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						prevCamFollow = camFollow;
		
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
						FlxG.sound.music.stop();
						new FlxTimer().start(0.7);
						resetScore();
						//openSubState(new ResultsSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

						
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
				else
				{
					trace('WENT BACK TO FREEPLAY??');
					new FlxTimer().start(0.7);
					resetScore();
					LoadingState.loadAndSwitchState(new FreeplayState());
					//openSubState(new ResultsSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
			}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		//boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			shits = shits + 1;
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			bads = bads + 1;
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			goods = goods + 1;
			score = 200;
		} else {
			sicks = sicks + 1;
		}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (Stage.curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!Stage.curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var sploosh:FlxSprite = new FlxSprite(note.x, playerStrums.members[note.noteData].y);
		if (FlxG.save.data.noteSplash)
		{
			if (!Stage.curStage.startsWith('school'))
			{
				var tex:FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes');
				sploosh.frames = tex;
				sploosh.animation.addByPrefix('splash 0 0', 'note impact 1 purple', 24, false);
				sploosh.animation.addByPrefix('splash 0 1', 'note impact 1 blue', 24, false);
				sploosh.animation.addByPrefix('splash 0 2', 'note impact 1 green', 24, false);
				sploosh.animation.addByPrefix('splash 0 3', 'note impact 1 red', 24, false);
				sploosh.animation.addByPrefix('splash 0 4', 'note impact 1 yellow', 24, false);
				sploosh.animation.addByPrefix('splash 1 0', 'note impact 2 purple', 24, false);
				sploosh.animation.addByPrefix('splash 1 1', 'note impact 2 blue', 24, false);
				sploosh.animation.addByPrefix('splash 1 2', 'note impact 2 green', 24, false);
				sploosh.animation.addByPrefix('splash 1 3', 'note impact 2 red', 24, false);
				sploosh.animation.addByPrefix('splash 1 4', 'note impact 2 yellow', 24, false);
				if (daRating == 'sick')
				{
					add(sploosh);
					sploosh.scrollFactor.set();
					sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
					sploosh.alpha = 0.6;
					sploosh.offset.x += 85;
					sploosh.offset.y += 85;
					sploosh.animation.finishCallback = function(name) sploosh.kill();
				}
			}
			else
			{
				sploosh.loadGraphic(Paths.image('weeb/pixelUI/noteSplashes-pixels'), true, 50, 50);
				sploosh.animation.add('splash 0 0', [0, 1, 2, 3], 24, false);
				sploosh.animation.add('splash 1 0', [4, 5, 6, 7], 24, false);
				sploosh.animation.add('splash 0 1', [8, 9, 10, 11], 24, false);
				sploosh.animation.add('splash 1 1', [12, 13, 14, 15], 24, false);
				sploosh.animation.add('splash 0 2', [16, 17, 18, 19], 24, false);
				sploosh.animation.add('splash 1 2', [20, 21, 22, 23], 24, false);
				sploosh.animation.add('splash 0 3', [24, 25, 26, 27], 24, false);
				sploosh.animation.add('splash 1 3', [28, 29, 30, 31], 24, false);
				sploosh.animation.add('splash 0 4', [32, 33, 34, 35], 24, false);
				sploosh.animation.add('splash 1 4', [36, 37, 38, 39], 24, false);
				if (daRating == 'sick')
				{
					sploosh.setGraphicSize(Std.int(sploosh.width * daPixelZoom));
					sploosh.updateHitbox();
					sploosh.scrollFactor.set();
					add(sploosh);
					sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
					sploosh.alpha = 0.6;
					sploosh.offset.x += 85;
					sploosh.offset.y += 85;
					sploosh.animation.finishCallback = function(name) sploosh.kill();
				}
			}
		}

		var seperatedScore:Array<Int> = [];
		var comboSplit:Array<String> = (combo + "").split('');

		if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

		for(i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!Stage.curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
 				add(numScore);
			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function autoplayItLol():Void
		{
			var mania = 4;
	
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.curAnim.name == 'confirm' && !Stage.curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
	
				}
				else
					spr.centerOffsets();
	
				if (spr.animation.curAnim.name == 'confirm' && spr.animation.curAnim.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
	
			player2Strums.forEach(function(spr:FlxSprite)
			{
				switch (spr.ID)
				{
					case 0:
						if (strums2[0][1])
							spr.animation.play('static');
						strums2[0][1] = false;
					case 1:
						if (strums2[1][1])
							spr.animation.play('static');
						strums2[1][1] = false;
	
					case 2:
						if (strums2[2][1])
							spr.animation.play('static');
						strums2[2][1] = false;
					case 3:
						if (strums2[3][1])
							spr.animation.play('static');
						strums2[3][1] = false;
					case 4:
						if (strums2[4][1])
							spr.animation.play('static');
						strums2[4][1] = false;
				}
	
				if (spr.animation.curAnim.name == 'confirm' && !Stage.curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
	
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y < strumLineNotes.members[daNote.noteData % mania].y)
				{
					// Force good note hit regardless if it's too late to hit it or not as a fail safe
					if (daNote.canBeHit && daNote.mustPress || daNote.tooLate && daNote.mustPress)
					{
							goodNoteHit(daNote);
							boyfriend.holdTimer = 0;
							// manager2.clear();
							songMisses = 0;
							accuracy = 100.00;
						
					}
				}
			});
		}



		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var upHold:Bool = false;
				var downHold:Bool = false;
				var rightHold:Bool = false;
				var leftHold:Bool = false;	
			
				var noteHit:Int = 0;
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
	
	
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
						goodNoteHit(daNote);
				});
			}

			// PRESSES, check for note hits
			if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
			{
				boyfriend.holdTimer = 0;
	 
				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
	 
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					{
						if (directionList.contains(daNote.noteData))
						{
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
									{ // if it's the same note twice at < 10ms distance, just delete it
										// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
										dumbNotes.push(daNote);
										break;
									}
									else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
									{ // if daNote is earlier than existing note (coolNote), replace
										possibleNotes.remove(coolNote);
										possibleNotes.push(daNote);
										break;
								}
							}
						}
						else
						{
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});

				for (note in dumbNotes)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
				var dontCheck = false;

				for (i in 0...pressArray.length)
				{
					if (pressArray[i] && !directionList.contains(i))
						dontCheck = true;
				}
				if (perfectMode)
					goodNoteHit(possibleNotes[0]);
				else if (possibleNotes.length > 0 && !dontCheck || possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghosttaps)
								{
									for (shit in 0...pressArray.length)
										{ // if a direction is hit that shouldn't be
											if (pressArray[shit] && !directionList.contains(shit))
												noteMiss(shit);
										}
								}
							for (coolNote in possibleNotes)
								{
									if (pressArray[coolNote.noteData])
										{
											scoreTxt.color = FlxColor.WHITE;
											goodNoteHit(coolNote);
										}
								
									}
				
						}
						else if (!FlxG.save.data.ghosttaps)
							{
								for (shit in 0...pressArray.length)
									if (pressArray[shit])
										noteMiss(shit);
							}
			

			if(dontCheck && possibleNotes.length > 0)
			{
				boyfriend.playAnim('idle');
			}
		


	}

				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true)))
				{
					//spr.centerOffsets();
					//spr.offset.x -= 13;
					//spr.offset.y -= 13;
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
				playerStrums.forEach(function(spr:FlxSprite)
					{
						if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						{
							spr.animation.play('pressed');
						}
						if (!holdArray[spr.ID])
							spr.animation.play('static');
		
						if (spr.animation.curAnim.name == 'confirm' && !Stage.curStage.startsWith('school'))
						{
							spr.centerOffsets();
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
						else
							spr.centerOffsets();
					});
			player2Strums.forEach(function(spr:FlxSprite)
			{
				switch (spr.ID)
				{
					case 0:
						if (strums2[0][1])
							if (FlxG.save.data.player2Strums)
								spr.animation.play('static');
							strums2[0][1] = false;
					case 1:
						if (strums2[1][1])
							if (FlxG.save.data.player2Strums)
								spr.animation.play('static');
							strums2[1][1] = false;
	
					case 2:
						if (strums2[2][1])
							if (FlxG.save.data.player2Strums)
								spr.animation.play('static');
							strums2[2][1] = false;
					case 3:
						if (strums2[3][1])
							if (FlxG.save.data.player2Strums)
								spr.animation.play('static');
							strums2[3][1] = false;
	
				}
	
				if (spr.animation.curAnim.name == 'confirm' && !Stage.curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
	}

	function noteMiss(direction:Int = 1):Void
		{

			if (!boyfriend.stunned)
			{
				health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad') || FlxG.save.data.missCry)
				{
					gf.playAnim('sad');
				}
				combo = 0;
	
				songScore -= (songScore - 10) >= 0 ? 10 : songScore;

				if(FlxG.save.data.missSfx)
					{
						FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
						// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
						// FlxG.log.add('played imss note');
					}				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');
				if (FlxG.save.data.missShake)
					{
						camGame.shake(.0025,.1,null,true,X);
					}
				boyfriend.stunned = true;
				songMisses += 1;
					
				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
	
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
				}
			}
		}
		
	
		function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;


	
			if (leftP)
				noteMiss(0);
			if (downP)
				noteMiss(1);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
		}
	
		function noteCheck(keyP:Bool, note:Note):Void
			{
					if (keyP)
						goodNoteHit(note);
					else
					{
						badNoteCheck();
					}
					if (note.death == false && !note.isSustainNote) {
						totalNotesHit += 1;
					}
			}
	
		function goodNoteHit(note:Note):Void
		{
			if (note.death == true) {
				health -= 1;
			}
			if (!note.wasGoodHit)
			{
				if (!note.isSustainNote)
				{
					totalNotesHit += 1;
					if (!FlxG.save.data.autoplay)
						popUpScore(note.strumTime, note);
					combo += 1;
				} else {
					totalNotesHit += 1;
				}
	
				if (note.noteData >= 0)
					health += 0.023;
				else
					health += 0.004;
	
				switch (note.noteData)
				{
					case 0:
						boyfriend.playAnim('singLEFT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
				}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						if (!FlxG.save.data.autoplay)
							spr.animation.play('confirm', true);
					}
				});
	
				note.wasGoodHit = true;
				vocals.volume = 1;
	
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
					boyfriend.holdTimer = 0;
				}
			}
		}
	

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		var fastCar = Stage.swagBacks['fastCar'];
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		Stage.swagBacks['fastCar'].velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		camGame.shake(.0025,.1,null,true,X);
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			var phillyTrain = Stage.swagBacks['phillyTrain'];
			camGame.shake(.0025,.1,null,true,X);
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		Stage.swagBacks['phillyTrain'].x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		Stage.swagBacks['halloweenBG'].animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		for (step in Stage.slowBacks.keys())
			{
				if (step == curStep)
				{
					if (Stage.hideLastBG)
					{
						for (bg in Stage.swagBacks)
						{
							if (!Stage.slowBacks[step].contains(bg))
								FlxTween.tween(bg, {alpha: 0}, Stage.tweenDuration);
						}
						for (bg in Stage.slowBacks[step])
						{
							FlxTween.tween(bg, {alpha: 1}, Stage.tweenDuration);
						}
					}
					else
					{
						for (bg in Stage.slowBacks[step])
							bg.visible = !bg.visible;
					}
				}
			}
	
	

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.DESCENDING : FlxSort.ASCENDING));
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (FlxG.save.data.cameraPulse)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && !FlxG.save.data.cameraPulse)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
		}
		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (Stage.curStage)
		{
			case 'school':
				if (Stage.swagBacks['bgGirls'] != null)
					Stage.swagBacks['bgGirls'].dance();
			case 'mall':
				for (bg in Stage.animatedBacks)
					bg.animation.play('idle');
			case 'limo':
				Stage.swagGroup['grpLimoDancers'].forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{

					var phillyCityLights = Stage.swagGroup['phillyCityLights'];
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					//phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	override function add(Object:FlxBasic):FlxBasic
		{
			trackedAssets.insert(trackedAssets.length, Object);
			return super.add(Object);
		}
	
		function unloadAssets():Void
		{
			for (asset in trackedAssets)
			{
				remove(asset);
			}
		}

	var curLight:Int = 0;
}
