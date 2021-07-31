package;
import flixel.FlxG;
import NewOptions;
import flixel.FlxSprite;
import flixel.text.FlxText;
import haxe.Http;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;


class ChangelogState extends MusicBeatState
{

    public static var currChanges:String;
    public static var needVer:String;
    public function new()
        {
            super();

            #if debug
            var debugMark:Alphabet = new Alphabet(0,0,"DEBUG",false,false,false);
            debugMark.alpha = 0.4;
            add(debugMark);
            #end
            transIn = FlxTransitionableState.defaultTransIn;
            transOut = FlxTransitionableState.defaultTransOut;
            var gfDance:FlxSprite;
            gfDance = new FlxSprite(0, 0);
            gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
            gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
            gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
            gfDance.antialiasing = true;
            gfDance.alpha = 0.5;
            add(gfDance);
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
                needVer = returnedData[0];
                currChanges = returnedData[1];
            }

            var txt:FlxText = new FlxText(0, 0, FlxG.width,
                "The most recent version is " +  needVer + "."
                + "\n\nWhat's new:\n\n" + currChanges,
                32);
                txt.setFormat("VCR OSD Mono", 26, FlxColor.fromRGB(200, 200, 200), CENTER);
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
