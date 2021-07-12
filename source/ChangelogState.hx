package;
import flixel.FlxG;
import OptionsMenu;
import flixel.FlxSprite;
import flixel.text.FlxText;
import haxe.Http;
import flixel.util.FlxColor;


class ChangelogState extends MusicBeatState
{
    public function new()
        {
            super();
            var magenta:FlxSprite;
            magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
            magenta.scrollFactor.x = 0;
            magenta.scrollFactor.y = 0.18;
            magenta.setGraphicSize(Std.int(magenta.width * 1.1));
            magenta.updateHitbox();
            magenta.screenCenter();
            magenta.antialiasing = true;
            add(magenta);


            var http = new haxe.Http("https://raw.githubusercontent.com/brandoge91/funkin-bcb/master/version.downloadMe");
            var returnedData:Array<String> = [];
            
            http.onData = function (data:String)
            {
                returnedData[0] = data.substring(0, data.indexOf(';'));
                returnedData[1] = data.substring(data.indexOf('-'), data.length);
            }
            var txt:FlxText = new FlxText(0, 0, FlxG.width,
                "The most recent version is " +  OptionsMenuSubState.needVer + "."
                + "\n\nWhat's new:\n\n" + OptionsMenuSubState.currChanges,
                26);
                txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
                txt.borderColor = FlxColor.BLACK;
                txt.borderSize = 3;
                txt.borderStyle = FlxTextBorderStyle.OUTLINE;
                txt.screenCenter();
                txt.visible = true;
                add(txt);


            super.create();
        }

   override function update(elapsed:Float)
        {
            if (controls.BACK)
                {
                    FlxG.switchState(new OptionsMenuSubState());
                }
            super.update(elapsed);
        }

}
