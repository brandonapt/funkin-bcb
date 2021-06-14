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

class OptionsMenuSubState extends MusicBeatState
{
    var menuItems:Array<String> = ["Changelog"];
    public static var downscroll:Bool = false;
    var curSelected:Int = 0;
	var magenta:FlxSprite;
    var title:Alphabet;
    var grpMenuShit:FlxTypedGroup<Alphabet>;
    var descriptionTxt:FlxText;
    public static var needVer:String = "kjNKFJNKJNS LOL";
	public static var currChanges:String = "ef";
    var flxBG:FlxSprite;
    var currentDescription:String;


	public function new()
    {
        super();
        currentDescription = 'none';
        magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
        title = new Alphabet(0, 15, "OPTIONS", true, false);
        title.screenCenter(X);
        add(title);


      


        descriptionTxt = new FlxText(15, 675, 0, currentDescription, 25);
		descriptionTxt.setFormat("VCR OSD Mono", 29, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
      //  descriptionTxt.screenCenter(X);

        descriptionTxt.visible = true;
		add(descriptionTxt);



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
        super.create();

    }


    override function update(elapsed:Float)
    {
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
            if (controls.BACK)
                {
                    FlxG.switchState(new MainMenuState());
                }

                if (accepted)
                    {
                        var daSelected:String = menuItems[curSelected];
            
                        switch (daSelected)
                        {
                            case "Changelog":

                                var http = new haxe.Http("https://raw.githubusercontent.com/brandoge91/funkin-bcb/master/version.downloadMe");
                                var returnedData:Array<String> = [];
                                
                                http.onData = function (data:String)
                                {
                                    returnedData[0] = data.substring(0, data.indexOf(';'));
                                    returnedData[1] = data.substring(data.indexOf('-'), data.length);
                                }
                                var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                                bg.scrollFactor.set();
                                add(bg);
                                var txt:FlxText = new FlxText(0, 0, FlxG.width,
                                    "The most recent version is " +  needVer + "."
                                    + "\n\nWhat's new:\n\n" + currChanges,
                                    32);
                                    txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
                                    txt.borderColor = FlxColor.BLACK;
                                    txt.borderSize = 3;
                                    txt.borderStyle = FlxTextBorderStyle.OUTLINE;
                                    txt.screenCenter();
                                    txt.visible = true;
                                    add(txt);
                        }
                    }
        
    }
    override function destroy()
        {    
            super.destroy();
        }
        function changeSelection(change:Int = 0):Void
            {
                curSelected += change;
        
                if (curSelected < 0)
                    curSelected = menuItems.length - 1;
                if (curSelected >= menuItems.length)
                    curSelected = 0;
        
                var bullShit:Int = 0;
                if (curSelected == 0) {
                    descriptionTxt.text = "View the changelog.";
                }
        
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