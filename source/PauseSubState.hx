package;

import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;
	var leaving:Bool = false;


	var pauseMusic:FlxSound;
	var yourMom:FlxSound;
	public var bg:FlxSprite;
	public var levelInfo:FlxText;
	public var levelDifficulty:FlxText;

	public function new(x:Float, y:Float)
	{
		super();
		#if debug
		var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
		debugMark.alpha = 0.4;
		add(debugMark);
		#end

		if (PlayState.isStoryMode) {
			if (PlayState.storyPlaylist.length != 1) {
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Exit to menu'];
			}
		}

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		levelInfo = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);


		levelDifficulty = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);


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

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					if (!leaving)
						{
							FlxG.sound.play(Paths.sound('confirmMenu'));
							destroy();
							leaving = true;
						}
				case "Restart Song":
					FlxG.resetState();
					PlayState.resetScore();
				case "Skip Song":
					PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);
	
					var difficulty:String = "";
	
					if (PlayState.storyDifficulty == 0) {
						difficulty = '-easy';
					}
	
					if (PlayState.storyDifficulty == 2) {
						difficulty = '-hard';
					}
	
					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
	
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					PlayState.resetScore();
					FlxG.switchState(new PlayState());

							/*case "Your Mom":
					yourMom = new FlxSound().loadEmbedded(Paths.music('dab'), false, true);
					yourMom.volume = 0;
					yourMom.play(false, FlxG.random.int(0, Std.int(yourMom.length / 2)));

					yourMom.volume = 1;
					FlxG.sound.list.add(yourMom);
					*/
				case "Exit to menu":
					if (PlayState.isStoryMode)
						{
						FlxG.switchState(new StoryMenuState());
						PlayState.resetScore();
						} else {
						FlxG.switchState(new FreeplayState());
						PlayState.resetScore();
						}
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			//PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		FlxTween.tween(bg, {alpha: 0}, 0.5);
		for (i in 0...grpMenuShit.members.length)
		{
			if (i == curSelected)
			{
				FlxFlicker.flicker(grpMenuShit.members[i], 1, 0.06, false, false);
			}
			else
			{
				FlxTween.tween(grpMenuShit.members[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
			}
		}
		FlxTween.tween(levelInfo, {alpha: 0, y: 15}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelDifficulty, {alpha: 0, y: 15}, 0.5, {ease: FlxEase.quartInOut});
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			close();
		});
	}

	function changeSelection(change:Int = 0):Void
	{
		if (!leaving)
			{
		curSelected += change;
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
	}
	}
}