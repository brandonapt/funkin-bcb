package;

import flixel.util.FlxTimer;
import NewOptions.OptionsMenuSubState;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import CoolUtil;
import flixel.FlxObject;
import flixel.FlxSprite;
import openfl.Assets;
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
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	public static var doneMoving:Bool = false;

	var modName:String = Assets.getText(Paths.txt('modName'));

	public static var lmaotext:FlxText;
	private var character:Character;


	public static var bg:FlxSprite;
	#if !switch
	var optionShit:Array<String> = [];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var trackedAssets:Array<Dynamic> = [];

	override function create()
	{

		if (FlxG.save.data.storymode == true)
			optionShit.push('story mode');
		if (FlxG.save.data.freeplay == true)
			optionShit.push('freeplay');
		optionShit.push('options');



		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			if (FlxG.save.data.sussyBakka)
				FlxG.sound.playMusic(Paths.music('MenuMusicAlt'));
			else
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		//magenta.scrollFactor.set();

		if (FlxG.save.data.sussyOption == null)
			FlxG.save.data.sussyOption = false;



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
		if (FlxG.save.data.watermarks == false)
			versionShit.text = '0.2.7.1';

		lmaotext = new FlxText(5, FlxG.height - 45, 0, modName, 12);
		lmaotext.scrollFactor.set();
		lmaotext.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(lmaotext);
		if (FlxG.save.data.watermarks == false)
			lmaotext.visible = false;



		// NG.core.calls.event.logEvent('swag').send();

		changeItem();


		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.P)
			{
				if (FlxG.save.data.sussyOption != null)
					FlxG.save.data.sussyOption = !FlxG.save.data.sussyOption;
				else
					FlxG.save.data.sussyOption = true;
			}
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

			//if (FlxG.keys.justPressed.P)
			//	{
			//		#if linux
			///		Sys.command('/usr/bin/xdg-open', ["https://raw.githubusercontent.com/brandoge91/funkin-bcb/main/news.downloadMe", "&"]);
				//	#else
				//	FlxG.openURL('https://raw.githubusercontent.com/brandoge91/funkin-bcb/main/news.downloadMen');
				//	#end
				//}

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
								FlxTween.tween(spr, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
							else
							{
								
									FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
									{
										goToState();
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

		function goToState()
			{									
				FlxTween.tween(menuItems.members[0],{y:-5000+menuItems.members[0].y},1,{ease:FlxEase.circIn});
				FlxTween.tween(menuItems.members[1],{y:-5000+menuItems.members[1].y},1,{ease:FlxEase.circIn});
				FlxTween.tween(menuItems.members[1],{y:-5000+menuItems.members[2].y},1,{ease:FlxEase.circIn,onComplete:function(e:FlxTween){
				var daChoice:String = optionShit[curSelected];
		
				switch (daChoice)
				{
					case 'story mode':
						FlxG.switchState(new StoryMenuState());
						trace("Story Menu Selected");
					case 'freeplay':
						FlxG.switchState(new FreeplayState());
		
						trace("Freeplay Menu Selected");
		
					case 'options':
						FlxG.switchState(new OptionsMenuSubState());
				}
				
				
			}});
			}
}
