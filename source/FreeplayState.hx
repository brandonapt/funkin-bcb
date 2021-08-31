package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	public static var songText:Alphabet;

	var scoreText:FlxText;
	var diffText:FlxText;
	var bg:FlxSprite;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var trackedAssets:Array<Dynamic> = [];

	override function create()
	{
		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
		debugMark.alpha = 0.4;
		add(debugMark);
		#end
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end


		// LOAD MUSIC

		// LOAD CHARACTERS
		if (FlxG.save.data.fpbg == true)
		{
			bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		} else {
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		}
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			songText = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			if (FlxG.save.data.freeplayIcons)
				{
					add(icon);
				}

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		 /*
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			 scoreText.textField.htmlText = md;

			trace(md);
		 

		super.create();
		*/
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var lockedIn:Bool = false;

	override function update(elapsed:Float)
	{

		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "High Score: " + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if (FlxG.save.data.playSongs == true)
				{
					if (FlxG.save.data.sussyBakka)
						FlxG.sound.playMusic(Paths.music('MenuMusicAlt'));
					else
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
			FlxG.switchState(new MainMenuState());
				
		}
		if (accepted)
			{
				var len = FlxG.sound.play(Paths.sound('confirmMenu')).length;
		grpSongs.forEach(function(e:Alphabet){

			trace('CUR WEEK' + PlayState.storyWeek);
			if (e.text == songs[curSelected].songName){
				FlxFlicker.flicker(e);
				FlxTween.tween(e, {x: e.x + 20}, len/1000,{onComplete:function(e:FlxTween){
					if (FlxG.keys.pressed.ALT){
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

						trace(poop);
			
						PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = curDifficulty;
			
						PlayState.storyWeek = songs[curSelected].week;
						FlxG.switchState(new ChartingState());
					}else{
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

						trace(poop);
			
						PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = curDifficulty;
			
						PlayState.storyWeek = songs[curSelected].week;
						LoadingState.loadAndSwitchState(new PlayState());

					}
				}});
		}//else{
			//	FlxFlicker.flicker(e);
			//	trace(curSelected);
			//	FlxTween.tween(e, {x: e.x + 20}, len/1000);
			//}
		
		
		
		
		});
	}
}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
{

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;



		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		if (FlxG.save.data.fpbg == true)
		{
		if (curSelected >= 0)
			{
				if (curSelected >= 4)
				{
					if (curSelected >= 7)
					{
						if (curSelected >= 10)
						{
							if (curSelected >= 13)
							{
								if (curSelected >= 16)
								{
									FlxTween.color(bg, 0.5, bg.color, FlxColor.fromRGB(219, 101, 217));
								}
								else
								{
									FlxTween.color(bg, 0.5, bg.color, FlxColor.fromRGB(161, 212, 230));
								}
							}
							else
							{
								FlxTween.color(bg, 0.5, bg.color, FlxColor.fromRGB(230, 129, 221));
							}
						}
						else
						{
							FlxTween.color(bg, 0.5, bg.color, FlxColor.fromRGB(99, 12, 22));
						}
					}
					else
					{
						FlxTween.color(bg, 0.5, bg.color, FlxColor.fromRGB(39, 46, 66));
					}
				}
				else
				{
					FlxTween.color(bg, 0.5, bg.color, FlxColor.fromRGB(96, 66, 245));
				}
			}
		}

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		var temp:Int = curSelected;

		new FlxTimer().start(FlxG.random.float(0), function(tmr:FlxTimer)
		{
			if (curSelected == temp && !lockedIn)
			{
				#if !switch
				intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
				// lerpScore = 0;
				#end

				#if PRELOAD_ALL
				if (FlxG.save.data.playSongs == true) {
				FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 1);
				}
				#end
			}
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

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
