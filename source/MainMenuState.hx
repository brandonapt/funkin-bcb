package;

import OptionsMenu.OptionsMenuSubState;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
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

	public static var bg:FlxSprite;
	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
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

		var http = new haxe.Http("https://raw.githubusercontent.com/brandoge91/funkin-bcb/master/news.downloadMe");
		var returnedData:Array<String> = [];
		var date:String;
		var newst:String;
		
		http.onData = function (data:String)
		{
			returnedData[0] = data.substring(0, data.indexOf(';'));
			returnedData[1] = data.substring(data.indexOf('-'), data.length);
		}
		date = returnedData[0];
		newst = returnedData[1];
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			date + "\n\n NEWS:"
			+ newst,
			32);
			txt.setFormat("VCR OSD Mono", 26, FlxColor.fromRGB(200, 200, 200), CENTER);
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 3;
			txt.scrollFactor.set();
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.visible = true;
			add(txt);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-600, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			
		FlxTween.tween(menuItem, {x: 15}, 0.9, {ease: FlxEase.expoInOut});

			FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.50) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
					changeItem();

					doneMoving = true; 
				}});
		}

		FlxG.camera.follow(camFollow, null, 0.5);

		
		var newsBG:FlxSprite = new FlxSprite(3000, 210).makeGraphic(Std.int(FlxG.width * 0.35), 320, 0xFF000000);
		newsBG.alpha = 0.6;
		newsBG.scrollFactor.set();
		add(newsBG);



		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Version " + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var lmaotext:FlxText = new FlxText(5, FlxG.height - 45, 0, "Brandon's Custom Build", 12);
		lmaotext.scrollFactor.set();
		lmaotext.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(lmaotext);

		FlxTween.tween(newsBG,{x: 800},2,{ease: FlxEase.expoInOut});

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
							FlxTween.tween(spr,{y: -400},2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
								{ 
									changeItem();
								}});

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
}
