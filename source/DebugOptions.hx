package;
import djFlixel.gfx.BoxScroller;
import djA.DataT;
import djFlixel.gfx.pal.Pal_DB32;
import flixel.system.FlxAssets;
import djFlixel.ui.FlxMenu;
import flixel.FlxG;
import flixel.FlxSprite;
import djFlixel.D;

class DebugMenu extends MusicBeatState
{
    var menu:FlxMenu;

    var scid = 0;
	var sc:BoxScroller;

    var BGCOLS = [
		[1,2],
		[24,25],
		[14,16],
		[3,12],
		[14,25],
		[2,26]
	];


    
    override public function create()
        {
            var m = create_get_menu();
            add(m);
            m.goto('main');
            var bg1 = new FlxSprite();
			bg1.makeGraphic(FlxG.width, 18, 0xFF000000);
			add(D.align.screen(bg1, '-', 'b'));
            sc = new BoxScroller('images/menuBGBlue.png', 0, 0, FlxG.width, FlxG.height);
            sc.autoScrollX = 0.2;
            sc.autoScrollY = 0.2;
            scroller_next();
            add(sc);
            D.text.fix({c:Pal_DB32.COL[21], bc:Pal_DB32.COL[1], bt:2});
            
        }

        function scroller_next()
            {
                var C = DataT.arrayRandom(BGCOLS).copy();
                C[0] = Pal_DB32.COL[C[0]];	// Convert index to real color
                C[1] = Pal_DB32.COL[C[1]];
                
                //--
                scid++; if (scid > 5) scid = 1;
                var b = FlxAssets.resolveBitmapData('images/menuBGBlue');
                    b = D.bmu.replaceColors(b.clone(), [0xFFFFFFFF, 0xFF000000], C);
                sc.loadNewGraphic(b);
            }
    
        function create_get_menu()
            {
                // -- MENU
                var m = new FlxMenu(32, 32, 140);
                
                // -- Customize fonts and colors:
                m.stI.text = {
                    f:"fonts/vcr.ttf",
                    s:16,
                    bt:1, so:[1, 1]
                };
                m.stI.col_t = {
                    idle:Pal_DB32.COL[21],
                    focus:Pal_DB32.COL[28],
                    accent:Pal_DB32.COL[29],
                    dis:Pal_DB32.COL[25],	// Disabled
                    dis_f:Pal_DB32.COL[23], // Disabled focused
                    
                };
                m.stI.col_b = {
                    idle:Pal_DB32.COL[1],
                    focus:Pal_DB32.COL[0]
                };
                m.stHeader = {
                    f:"fonts/vcr.ttf",
                    s:16,bt:2,bs:1,
                    c:Pal_DB32.COL[8],
                    bc:Pal_DB32.COL[27]
                };
                m.PARAMS.header_CPS = 30;
                m.PARAMS.page_anim_parallel = true;
                    
                // -- Create some pages
                m.createPage('main','This is an FlxMenu').addM([
                    'Slides Demo |link|sdemo',
                    'Menu Demo|link|@mdemo',
                    'FlxAutotext Demo|link|autot',
                    'Simple Game Demo|link|game1',
                    'Options|link|@options',
                    'Reset|link|#rst'	// # will create a popup confirmation
                ]);
                m.createPage('options', "Options").addM([
                    'Fullscreen|toggle|id=fs',
                    'Smoothing|toggle|id=sm',
                    'Volume|range|id=vol|range=0,100|step=5',
                    #if(desktop)
                    'Windowed Mode|range|id=winmode|range=1,${D.MAX_WINDOW_ZOOM}',
                    #end
                    'Change Background|link|bgcol',
                    'Back|link|@back'
                ]);
                
                var p = m.createPage('mdemo').addM([
                    'Mousewheel to scroll|link|0', // Putting 0 as id, because it needs an ID
                    'or buttons to navigate as normal|link|0',
                    ':test label:|label',
                    'Disabled - |link|dtest',
                    'Toggle above ^|link|dtog',
                    '----|link|0',
                    'Toggle Item|toggle|c=false|id=0', // Note. I need to specify "id=0", unlike links which don't need "id="
                    'List Item|list|list=one,two,three,four,five|c=0|id=0',
                    'Range Item|range|range=0,1|step=0.1|c=0.5|id=0',
                    'BACK|link|@back'
                ]);
                
                //---------------------------------------------------;
                // Customize the ItemStyle and ListStyle for this specific page
                p.params.stI = {
                    text : {f:"fonts/vcr.ttf", s:16, bt:2},
                    box_bm : [ // Custom checkbox icons
                        D.ui.getIcon(12, 'ch_off'), D.ui.getIcon(12, 'ch_on')
                    ], 
                    ar_bm : [ // Custom Slider/List Arrows
                        D.ui.getIcon(12, 'ar_left'), D.ui.getIcon(12, 'ar_right')
                    ],
                    ar_anim : "2,2,0.5"
                };
                p.params.stL = {
                    align:'justify',
                    other:'yes'
                }
                //---------------------------------------------------;
        
                // More initialization of some items 
                m.pages.get('mdemo').get('dtest').disabled = true;
                m.pages.get('main').get('rst').data.tStyle = {bt:2, s:8, f:null}; // < Change the popup text style
                
                m.onMenuEvent = (a, b)->{
                    
                    if (a == pageCall) {
                        D.snd.playV('cursor_high',0.6);
                    }else
                    if (a == back){
                        D.snd.playV('cursor_low');
                    }
                    
                    // Just went to the options page
                    if (a == page && b == "options") {
                        // Alter the menu items data, to reflect current environment
                        // (2) , is the index starting from 0, I could pass the ID to get the item also
                        m.item_update(0, (t)->{t.data.c = FlxG.fullscreen; });
                        m.item_update(1, (t)->{t.data.c = D.SMOOTHING; });
                        m.item_update(2, (t)->{t.data.c = Std.int(FlxG.sound.volume * 100); });	
                    }
                };
                
                m.onItemEvent = (a, b)->{
                    // 
                    if (a == fire) switch(b.ID){
                        case "fs":
                            FlxG.fullscreen = b.data.c;
                        case "sm":
                            D.SMOOTHING = b.data.c;
                        case "vol":
                            FlxG.sound.volume = b.data.c / 100;
                        case "bgcol":
                            scroller_next();
                        case "dtog":
                            // Get the disabled item and modify it with this function
                            m.item_update('mdemo', 'dtest', (it)->{
                                it.disabled = !it.disabled;
                                it.label = it.disabled?'Disabled :-(':'Enabled - :-)';
                            });
                        case "winmode":
                            D.setWindowed(b.data.c);
                            m.item_update(0, (t)->{t.data.c = FlxG.fullscreen; });
                        case "sdemo": LoadingState.loadAndSwitchState(new FreeplayState());
                        case "autot": LoadingState.loadAndSwitchState(new TitleState());
                        case "game1": LoadingState.loadAndSwitchState(new MainMenuState());
                        case _:
                    };
                    
                    switch(a) {
                        case fire:
                            D.snd.playV('cursor_high',0.7);
                        case focus:
                            D.snd.playV('cursor_tick',0.4);
                        case invalid:
                            D.snd.playV('cursor_error');
                        case _:
                    };
                }//
                
                
                return m;
                
            }//-----
}