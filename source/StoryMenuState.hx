package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import CoolUtil;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	var loltext:FlxText;

	public static var curDifficulty:Int = 1;
	var hasChanged:Bool = false;
	var fade:FlxSprite;



	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true];

	static var weekData:Array<Array<String>> = [];
	static var weekCharacters:Array<Array<String>> = [];



/*
	var weekNames:Array<String> = [
		"how to Funk",
		"Daddy Dearest",
		"SPOOKY KIDS",
		"Pico",
		"Mommy Must Murder",
		"red snow",
		"HAtING SIMULATOR ft moawling"
	];
	*/



	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	public static var weekNames:Array<String>;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;

	var trackedAssets:Array<flixel.FlxBasic> = [];
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;


	public static function getWeeks():Array<Array<String>>
		{
			var initList = CoolUtil.coolTextFile(Paths.txt('weekData'));
			var swagGoodArray:Array<Array<String>> = [];
	
			for (i in 0...initList.length)
			{
				var data:Array<String> = initList[i].split(', ');
				swagGoodArray.push(data);
			}
	
			return swagGoodArray;
		}
	
		function getWeekCharacters():Array<Array<String>>
		{
			var initList = CoolUtil.coolTextFile(Paths.txt('storyMenuCharacters'));
			var swagGoodArray:Array<Array<String>> = [];
	
			for (i in 0...initList.length)
			{
				var data:Array<String> = initList[i].split(', ');
				swagGoodArray.push(data);
			}
	
			return swagGoodArray;
		}
	
	
	

	override function create()
	{
		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
		debugMark.alpha = 0.4;
		add(debugMark);
		#end
		weekData = getWeeks();
		weekCharacters = getWeekCharacters();
		var weekTxt = CoolUtil.coolTextFile(Paths.txt('weekNames'));
		weekNames = weekTxt;		
			
	
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;


		loltext = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		loltext.setFormat("VCR OSD Mono", 32);
		loltext.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();
		hasChanged = true;

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBG);
		add(grpWeekCharacters);

		fade = new FlxSprite(0).loadGraphic(Paths.image('fade_yellow'));
		fade.screenCenter(Y);

		//add(fade);



		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = loltext.font;
		txtTracklist.color = FlxColor.YELLOW;
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);


		add(loltext);


		updateText();

		trace("Line 165");

		super.create();


	}

	override function update(elapsed:Float)
	{
		var rank:String = ".";

		if (curWeek == 0) {
			rightArrow.visible = false;
			leftArrow.visible = false;
			sprDifficulty.visible = false;
		} else {
			rightArrow.visible = true;
			leftArrow.visible = true;
			sprDifficulty.visible = true;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));
		



		if (curWeek != 0)
		{
			switch (curDifficulty)
			{
				case 0:
					FlxTween.color(txtTracklist, 0.1, txtTracklist.color, FlxColor.LIME);
				case 1:
					FlxTween.color(txtTracklist, 0.1, txtTracklist.color, FlxColor.YELLOW);
				case 2:
					FlxTween.color(txtTracklist, 0.1, txtTracklist.color, FlxColor.RED);
				
			}
		}
		if (curWeek == 0)
			FlxTween.color(txtTracklist, 0.1, txtTracklist.color, FlxColor.YELLOW);
		scoreText.text = "High Score: " + lerpScore;




		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

				lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

				new FlxTimer().start(0.3, function(tmr:FlxTimer)
					{
						if (lerpScore == 0)
							{
								rank = "Unattempted";
							}
				
						if (lerpScore <= 3000)
						{
										if (lerpScore >= 1)
										{
							rank = "Bad";
										}
						}
						
						if (lerpScore >= 7500)
						{
							rank = "Okay";
						}
						if (lerpScore >= 20000)
						{
							rank = "Great";
						}
				
						loltext.text = "Rank: " + rank;
					});




		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);

		
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				new FlxTimer().start(0.7);
 
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}
			if (curWeek == 0) {
				diffic = "";
				curDifficulty = 1;
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				//FlxG.camera.fade(FlxColor.BLACK, 1.3, true);
				LoadingState.loadAndSwitchState(new PlayState(), true);
				//FlxG.switchState(new VideoState('paint', new PlayState()));
				//FlxG.switchState(new VideoState('assets/videos/paint.webm', function(){
				//	trace('lol');
				//	new FlxTimer().start(1, function (tmr:FlxTimer)
				//	{
				//		FlxG.switchState(new PlayState());
				//	});
				//}, 100, true));
			});
		}
	}


	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y + 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {alpha: 1}, 0.1);
		
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	

	function changeWeek(change:Int = 0):Void
	{

		


	
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;
		

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}


		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{


		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);
		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
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

