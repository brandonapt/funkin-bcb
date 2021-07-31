package;

import flixel.util.FlxTimer;
import NewOptions.OptionsMenuSubState;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.touch.FlxTouch;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import haxe.Http;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	public static var doneMoving:Bool = false;

	public static var lmaotext:FlxText;

	public static var bg:FlxSprite;
	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var trackedAssets:Array<Dynamic> = [];

	override function create()
	{

		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
		debugMark.alpha = 0.4;
		add(debugMark);
		#end
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.2));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		//magenta.scrollFactor.set();



		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(5000, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			

			FlxTween.tween(menuItem,{x: 15},1 ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
					changeItem();

					doneMoving = true; 
				}});
		}

		FlxG.camera.follow(camFollow, null, 0.5);





		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Version " + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		lmaotext = new FlxText(5, FlxG.height - 45, 0, "Brandon's Custom Build", 12);
		lmaotext.scrollFactor.set();
		lmaotext.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(lmaotext);



		// NG.core.calls.event.logEvent('swag').send();

		changeItem();


		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			for (touch in FlxG.touches.list)
				{
					if (touch.justPressed) {
						if (touch.x == lmaotext.x)
							trace('poopddd');
					}
					if (touch.pressed) {}
					if (touch.justReleased) {}
				}
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				doneMoving = false;
				FlxG.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.P)
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://raw.githubusercontent.com/brandoge91/funkin-bcb/main/news.downloadMe", "&"]);
					#else
					FlxG.openURL('https://raw.githubusercontent.com/brandoge91/funkin-bcb/main/news.downloadMen');
					#end
				}

			if (controls.ACCEPT)
			{
				doneMoving = false;
				if (optionShit[curSelected] == 'donate')
				{
					//#if linux
					//Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					//#else
					//FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					//#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					


					FlxFlicker.flicker(magenta, 1.1, 0.15, false);
					

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
									changeItem();

								menuItems.forEach(function(spr:FlxSprite)
									{
										//FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
										//FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
										FlxTween.tween(spr, {x: -600}, 0.6, {
											ease: FlxEase.backIn,
											onComplete: function(twn:FlxTween)
											{
												spr.kill();
											}
										});
									});

							FlxTween.tween(spr, {alpha: 0}, 0.2, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
							
						};
						else
						{
							FlxTween.tween(spr,{y: -400},2 ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
								{ 
									changeItem();
								}});

							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];
								new FlxTimer().start(0.7);

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");
									case 'donate':
										#if linux
										Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
										#else
										FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
										#end
									case 'options':
										FlxG.switchState(new OptionsMenuSubState());
										MainVariables.initSave();

									
								}

							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{

		if (doneMoving)
			{
				curSelected += huh;
	
				if (curSelected >= menuItems.length)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
			}
			
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && doneMoving)
			{
				spr.animation.play('selected');

				//HEREL
				//FlxTween.tween(spr, {x: spr.x + 50}, 0.4);
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	
	override function add(Object:flixel.FlxBasic):flixel.FlxBasic
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
}
