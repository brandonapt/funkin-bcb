#if desktop
import openfl.display3D.textures.VideoTexture;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxEase;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import lime.app.Application;
import flixel.FlxSprite;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;

class LuaState 
{
	public static var lua:State;

    public function executeState(name,args:Array<Dynamic>)
        {
            return Lua.tostring(lua,callLua(name, args));
        }
    
        public static function createModchartState():LuaState
        {
            return new LuaState();
        }


    function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
        {
            var result : Any = null;
    
            Lua.getglobal(lua, func_name);
    
            for( arg in args ) {
            Convert.toLua(lua, arg);
            }
    
            result = Lua.pcall(lua, args.length, 1, 0);
            var p = Lua.tostring(lua,result);
            var e = getLuaErrorMessage(lua);
    
            if (e != null)
            {
                if (p != null)
                    {
                        Application.current.window.alert("LUA ERROR:\n" + p + "\nhaxe err: " + e,"POOPYHEADPOOP");
                        lua = null;
                        LoadingState.loadAndSwitchState(new MainMenuState());
                    }
                // trace('err: ' + e);
            }
            if( result == null) {
                return null;
            } else {
                return convert(result, type);
            }
    
        }


        static function toLua(l:State, val:Any):Bool {
            switch (Type.typeof(val)) {
                case Type.ValueType.TNull:
                    Lua.pushnil(l);
                case Type.ValueType.TBool:
                    Lua.pushboolean(l, val);
                case Type.ValueType.TInt:
                    Lua.pushinteger(l, cast(val, Int));
                case Type.ValueType.TFloat:
                    Lua.pushnumber(l, val);
                case Type.ValueType.TClass(String):
                    Lua.pushstring(l, cast(val, String));
                case Type.ValueType.TClass(Array):
                    Convert.arrayToLua(l, val);
                case Type.ValueType.TObject:
                    objectToLua(l, val);
                default:
                    trace("haxe value not supported - " + val + " which is a type of " + Type.typeof(val));
                    return false;
            }
    
            return true;
    
        }

        static function objectToLua(l:State, res:Any) {

            var FUCK = 0;
            for(n in Reflect.fields(res))
            {
                trace(Type.typeof(n).getName());
                FUCK++;
            }
    
            Lua.createtable(l, FUCK, 0); // TODONE: I did it
    
            for (n in Reflect.fields(res)){
                if (!Reflect.isObject(n))
                    continue;
                Lua.pushstring(l, n);
                toLua(l, Reflect.field(res, n));
                Lua.settable(l, -3);
            }
    
        }
    
        function getType(l, type):Any
        {
            return switch Lua.type(l,type) {
                case t if (t == Lua.LUA_TNIL): null;
                case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
                case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
                case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
                case t: throw 'you don goofed up. lua type error ($t)';
            }
        }
    
        function getReturnValues(l) {
            var lua_v:Int;
            var v:Any = null;
            while((lua_v = Lua.gettop(l)) != 0) {
                var type:String = getType(l,lua_v);
                v = convert(lua_v, type);
                Lua.pop(l, 1);
            }
            return v;
        }
    
    
        private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
            if( Std.is(v, String) && type != null ) {
            var v : String = v;
            if( type.substr(0, 4) == 'array' ) {
                if( type.substr(4) == 'float' ) {
                var array : Array<String> = v.split(',');
                var array2 : Array<Float> = new Array();
    
                for( vars in array ) {
                    array2.push(Std.parseFloat(vars));
                }
    
                return array2;
                } else if( type.substr(4) == 'int' ) {
                var array : Array<String> = v.split(',');
                var array2 : Array<Int> = new Array();
    
                for( vars in array ) {
                    array2.push(Std.parseInt(vars));
                }
    
                return array2;
                } else {
                var array : Array<String> = v.split(',');
                return array;
                }
            } else if( type == 'float' ) {
                return Std.parseFloat(v);
            } else if( type == 'int' ) {
                return Std.parseInt(v);
            } else if( type == 'bool' ) {
                if( v == 'true' ) {
                return true;
                } else {
                return false;
                }
            } else {
                return v;
            }
            } else {
            return v;
            }
        }
    
        function getLuaErrorMessage(l) {
            var v:String = Lua.tostring(l, -1);
            Lua.pop(l, 1);
            return v;
        }
    
        public function setVar(var_name : String, object : Dynamic){
            // trace('setting variable ' + var_name + ' to ' + object);
    
            Lua.pushnumber(lua,object);
            Lua.setglobal(lua, var_name);
        }
    
        public function getVar(var_name : String, type : String) : Dynamic {
            var result : Any = null;
    
            // trace('getting variable ' + var_name + ' with a type of ' + type);
    
            Lua.getglobal(lua, var_name);
            result = Convert.fromLua(lua,-1);
            Lua.pop(lua,1);
    
            if( result == null ) {
            return null;
            } else {
            var result = convert(result, type);
            //trace(var_name + ' result: ' + result);
            return result;
            }
        }

        public function die()
            {
                Lua.close(lua);
                lua = null;
            }
        
            public var luaWiggles:Map<String,WiggleEffect> = new Map<String,WiggleEffect>();
        
            // LUA SHIT
        
            function new()
            {
                        trace('opening a lua state (because we are cool :))');
                        lua = LuaL.newstate();
                        LuaL.openlibs(lua);
                        trace("Lua version: " + Lua.version());
                        trace("LuaJIT version: " + Lua.versionJIT());
                        Lua.init_callbacks(lua);
                        
                        //shaders = new Array<LuaShader>();
        
                        // pre lowercasing the song name (new)
                        var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();

        
                        var path = Paths.lua(songLowercase + "/modchart");
        
                        var result = LuaL.dofile(lua, path); // execute le file
            
                        if (result != 0)
                        {
                            Application.current.window.alert("LUA COMPILE ERROR:\n" + Lua.tostring(lua,result),"Kade Engine Modcharts");
                            lua = null;
                            LoadingState.loadAndSwitchState(new MainMenuState());
                        }
        
                        // get some fukin globals up in here bois
            
                        setVar("difficulty", PlayState.storyDifficulty);
                        setVar("song", PlayState.SONG.song.toLowerCase());
                        setVar('currentStage', PlayState.Stage.curStage);
                        
 
                        }
            }



#end