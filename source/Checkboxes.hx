package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Checkboxes extends FlxSprite
{
	
	public var sprTracker:FlxSprite;

	public function new()
	{
		super();
        frames = Paths.getSparrowAtlas('checkboxThingie');
        frames = frames;
        animation.addByPrefix('selected', 'Check Box Selected Static', 1, true);
        animation.addByPrefix('unselected', 'Check Box unselected', 0, true);
        animation.addByPrefix('select', 'Check Box selecting animation', 10, false);
        animation.play('select');
        scrollFactor.set(); 

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 130);
	}
}