package;

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

class ResultsSubState extends MusicBeatSubstate
{

	var pauseMusic:FlxSound;
    var worses = PlayState.shits;
var bads = PlayState.bads;
var goods = PlayState.goods;
var sicks = PlayState.sicks;
var misses = PlayState.songMisses;
var accuracy = PlayState.accuracy;
var score = PlayState.songScore;
var notesHit = PlayState.totalNotesHit;
var totalNotes = PlayState.totalPlayed;
var songName = PlayState.SONG.song;
var player2 = PlayState.SONG.player2;
var autoplay:Bool = false;



	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});






		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

        


	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
}