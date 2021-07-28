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

		var titleText = new FlxText(0,15,0,"Song Complete!",32);
		titleText.bold = true;
		titleText.screenCenter(X);
		titleText.alpha = 0;
		add(titleText);

		var ratingsText = new FlxText(0,80,0,"Sicks: " + sicks + "\nGoods: " + goods + "\nBads: " + bads + "\nShits: " + worses,20);
		ratingsText.alpha = 0;
		add(ratingsText);

		var sicks = new FlxText(20,50,0,"Sicks: " + sicks, 25);
		sicks.alpha = 0;
		add(sicks);

		var goods = new FlxText(20,80,0,"Goods: " + goods, 25);
		goods.alpha = 0;
		add(goods);

		var bads = new FlxText(20,110,0,"Bads: " + bads, 25);
		bads.alpha = 0;
		add(bads);

		var shits = new FlxText(20,140,0,"Shits: " + worses, 25);
		shits.alpha = 0;
		add(shits);

		var misses = new FlxText(20,210,0,"Misses: " + misses, 25);
		misses.alpha = 0;
		add(misses);

		var controls = new FlxText(20,FlxG.width - 18,0,"Press ENTER to continue", 20);
		controls.alpha = 0;
		add(controls);



        FlxTween.tween(bg, {alpha: 0.6}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(titleText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		//FlxTween.tween(ratingsText, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
		FlxTween.tween(sicks, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(goods, {alpha: 1}, 1.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(bads, {alpha: 1}, 2, {ease: FlxEase.quartInOut});
		FlxTween.tween(shits, {alpha: 1}, 2.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(misses, {alpha: 1}, 3, {ease: FlxEase.quartInOut});
		FlxTween.tween(controls, {alpha: 1}, 4, {ease: FlxEase.quartInOut});








		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
		if (FlxG.keys.justPressed.ENTER)
			{
				if (PlayState.isStoryMode) {
					if (PlayState.storyPlaylist.length != 1) {
				LoadingState.loadAndSwitchState(new PlayState());
					} else {
						FlxG.switchState(new StoryMenuState());
					}
				} else {
					FlxG.switchState(new FreeplayState());
				}
			}

		super.update(elapsed);

        


	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
}