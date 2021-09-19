package;
import flixel.addons.api.FlxGameJolt;

class GameJolt
{
    public function authenticateUser(username:String, userToken:String, callbackfunction:Dynamic)
        {
            FlxGameJolt.authUser(username, userToken, callbackfunction);
            return FlxGameJolt.initialized;
        }
    public function addScore(score:String, Sort:Float, ?TableID:Int, AllowGuestToEarn:Bool = false, ?GuestName:String, ?ExtraData:String, ?CallbackFunction:Dynamic)
        {
            FlxGameJolt.addScore()
        }
}