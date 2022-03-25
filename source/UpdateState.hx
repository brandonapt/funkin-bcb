package;

import flixel.FlxSprite;
import MusicBeatState;
import flixel.FlxG;
import TitleState;
import haxe.Http;
import Alphabet;

class UpdateState extends MusicBeatState 
{
    override function create() {
        var magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        magenta.scrollFactor.x = 0;
        magenta.scrollFactor.y = 0.18;
        magenta.setGraphicSize(Std.int(magenta.width * 1.1));
        magenta.updateHitbox();
        magenta.screenCenter();
        magenta.antialiasing = true;
        magenta.color = 0xFDdF819b;
        add(magenta);
        var updatingText:Alphabet = new Alphabet(0,25,'Updating...',true,false,false,1,1);
        updatingText.screenCenter(X);
        add(updatingText);

        var downloadedText:Alphabet = new Alphabet(0,55,'FILE.PNG',false,false,false,1,1);
        downloadedText.screenCenter();
        add(downloadedText);


    }    
    override function update (elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new TitleState());
        }
        
    }



}