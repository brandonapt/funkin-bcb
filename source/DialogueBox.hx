package;

import cpp.abi.Abi;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var senpai:FlxSprite;
	var bfPixel:FlxSprite;
	var spirit:FlxSprite;
	var bf:FlxSprite;
	var dad:FlxSprite;
	var spooky:FlxSprite;
	var pico:FlxSprite;
	var mom:FlxSprite;
	var christmas:FlxSprite;
	var monster:FlxSprite;
	var gf:FlxSprite;



	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

	
			FlxTween.tween(bgFade, {alpha: 0.7}, 0.8, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
					{
						
					}
				});

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'tutorial':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.visible = false;
			case 'bopeebo':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.visible = false;
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				//add(face);
						//face.alpha += 1 / 5;
						//FlxTween.tween(face, {alpha: 1}, 0.8, {
						//	ease: FlxEase.quadOut,
						//	onComplete: function(twn:FlxTween)
						//		{
						//			
						//		}
						//	});
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		senpai = new FlxSprite(-20,40);
		senpai.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		senpai.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		senpai.setGraphicSize(Std.int(senpai.width * PlayState.daPixelZoom * 0.9));
		senpai.updateHitbox();
		senpai.scrollFactor.set();
		add(senpai);
		senpai.visible = false;
		senpai.screenCenter(X);

		bfPixel = new FlxSprite(0, 40);
		bfPixel.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		bfPixel.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		bfPixel.setGraphicSize(Std.int(bfPixel.width * PlayState.daPixelZoom * 0.9));
		bfPixel.updateHitbox();
		bfPixel.scrollFactor.set();
		add(bfPixel);
		bfPixel.visible = false;

		dad = new FlxSprite(80, 60);
		dad.loadGraphic(Paths.image('dialogue/dad'));
		//portraitLeft.animation.addByPrefix('enter', 'BF idle dance', 12, true);
		dad.setGraphicSize(Std.int(dad.width * 0.8));
		dad.updateHitbox();
		dad.scrollFactor.set();
		add(dad);
		dad.visible = false;

		mom = new FlxSprite(80, 60);
		mom.loadGraphic(Paths.image('dialogue/mom'));
		//portraitLeft.animation.addByPrefix('enter', 'BF idle dance', 12, true);
		mom.setGraphicSize(Std.int(mom.width * 0.8));
		mom.updateHitbox();
		mom.scrollFactor.set();
		add(mom);
		mom.visible = false;

		monster = new FlxSprite(80, 60);
		monster.loadGraphic(Paths.image('dialogue/monster'));
		//portraitLeft.animation.addByPrefix('enter', 'BF idle dance', 12, true);
		monster.setGraphicSize(Std.int(monster.width * 0.8));
		monster.updateHitbox();
		monster.scrollFactor.set();
		add(monster);
		monster.visible = false;

		christmas = new FlxSprite(80, 60);
		christmas.loadGraphic(Paths.image('dialogue/parents'));
		//portraitLeft.animation.addByPrefix('enter', 'BF idle dance', 12, true);
		christmas.setGraphicSize(Std.int(christmas.width * 0.8));
		christmas.updateHitbox();
		christmas.scrollFactor.set();
		add(christmas);
		christmas.visible = false;

		spirit = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
		spirit.setGraphicSize(Std.int(spirit.width * 6));
		spirit.scrollFactor.set();
		add(spirit);
		spirit.visible = false;

		pico = new FlxSprite(80, 60);
		pico.loadGraphic(Paths.image('dialogue/pico'));
		//portraitLeft.animation.addByPrefix('enter', 'BF idle dance', 12, true);
		pico.setGraphicSize(Std.int(pico.width * 0.8));
		pico.updateHitbox();
		pico.scrollFactor.set();
		add(pico);
		pico.visible = false;

		spooky = new FlxSprite(80, 60);
		spooky.loadGraphic(Paths.image('dialogue/spooky'));
		//portraitLeft.animation.addByPrefix('enter', 'BF idle dance', 12, true);
		spooky.setGraphicSize(Std.int(spooky.width * 0.8));
		spooky.updateHitbox();
		spooky.scrollFactor.set();
		add(spooky);
		spooky.visible = false;
		
		bf = new FlxSprite(765, 60);
		bf.loadGraphic(Paths.image('dialogue/bf'));
		//portraitRight.animation.addByPrefix('enter', 'GF Dancing Beat', 12, true);
		bf.setGraphicSize(Std.int(bf.width * 0.8));
		bf.updateHitbox();
		bf.scrollFactor.set();
		add(bf);
		bf.visible = false;

		gf = new FlxSprite(80, 60);
		gf.loadGraphic(Paths.image('dialogue/gf'));
	//	gf.animation.addByPrefix('enter', 'GF Dancing Beat', 12, true);
		gf.setGraphicSize(Std.int(gf.width * 0.9));
		gf.updateHitbox();
		gf.scrollFactor.set();
		add(gf);
		gf.visible = false;
	
	switch (PlayState.SONG.song.toLowerCase())
	{
		case 'senpai':
			box.animation.play('normalOpen');
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			box.updateHitbox();
			add(box);
			box.screenCenter(X);
			handSelect = new FlxSprite(FlxG.width * 1, FlxG.height * 1).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
			add(handSelect);
			case 'roses':
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();
				add(box);
				box.screenCenter(X);
				handSelect = new FlxSprite(FlxG.width * 1, FlxG.height * 1).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				add(handSelect);
			case 'thorns':
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();
				add(box);
				box.screenCenter(X);
				handSelect = new FlxSprite(FlxG.width * 1, FlxG.height * 1).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				add(handSelect);
			case 'bopeebo':
				box.visible = true;
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * 0.9));
				box.updateHitbox();
				box.offset.y -= 335;
				add(box);

				box.screenCenter(X);
			default:

				box.visible = true;
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * 0.9));
				box.updateHitbox();
				box.offset.y -= 335;
				add(box);

				box.screenCenter(X);
				//portraitLeft.screenCenter(X);

		}

    
		if (!talkingRight)
		{
			// box.flipX = true;
		}
		
		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "-", 32);
		if (PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns'|| PlayState.SONG.song.toLowerCase() == 'senpai')
			{
				dropText.font = 'Pixel Arial 11 Bold';
			}else{
				dropText.setFormat(Paths.font("vcr.ttf"), 24);
		}
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "-", 32);
		if (PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns'|| PlayState.SONG.song.toLowerCase() == 'senpai')
		{
			swagDialogue.font = 'Pixel Arial 11 Bold';
		} else {
			swagDialogue.setFormat(Paths.font("vcr.ttf"), 24);

	}
	swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

		swagDialogue.color = 0xFF3F2021;

		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			senpai.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}


		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ENTER  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						pico.visible = false;
						bf.visible = false;
						bfPixel.visible = false;
						senpai.visible = false;
						spirit.visible = false;
						spooky.visible = false;
						christmas.visible = false;
						dad.visible = false;
						monster.visible = false;
						gf.visible = false;

						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		dropText.text = swagDialogue.text;

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		pico.visible = false;
		bf.visible = false;
		bfPixel.visible = false;
		senpai.visible = false;
		dad.visible = false;
		spirit.visible = false;
		spooky.visible = false;
		christmas.visible = false;
		monster.visible = false;
		gf.visible = false;

		switch (curCharacter)
		{
			case 'dad':
				dad.visible = false;
				if (!dad.visible)
				{
					dad.visible = true;
					//dad.animation.play('enter');
				}
			case 'bf':
				bf.visible = false;
				if (!bf.visible)
				{
					bf.visible = true;
					//bf.animation.play('enter');
				}
			case 'pico':
				pico.visible = false;
				if (!pico.visible)
				{
					pico.visible = true;
					//bf.animation.play('enter');
				}
			case 'spooky':
				spooky.visible = false;
				if (!spooky.visible)
				{
					spooky.visible = true;
						//bf.animation.play('enter');
				}
			case 'bfPixel':
				bfPixel.visible = false;
				if (!bfPixel.visible)
				{
					bfPixel.visible = true;
					bfPixel.animation.play('enter');
				}
			case 'senpai':
				senpai.visible = false;
				if (!senpai.visible)
				{
					senpai.visible = true;
					senpai.animation.play('enter');
				}
			case 'christmas':
				christmas.visible = false;
				if (!christmas.visible)
				{
					christmas.visible = true;
						//bf.animation.play('enter');
				}
			case 'monster':
				monster.visible = false;
				if (!monster.visible)
				{
					monster.visible = true;
						//bf.animation.play('enter');
				}
			case 'gf':
				gf.visible = false;
				if (!gf.visible)
				{
					gf.visible = true;
						//bf.animation.play('enter');
				}
			case 'spirit':
				spirit.visible = false;
				if (!spirit.visible)
				{
					spirit.visible = true;
						//bf.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
