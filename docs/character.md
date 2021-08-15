Okay, adding a character is very simple. 

Prerequirements:
You have followed and test-built the game using the [Building Guide](/funkin-bcb/building).
You have the character files in PNG format and an XML sprite guide in the folder **assets/shared/images/peoples/**.

Then, once you meet the prerequirements, you can go ahead and add a new entry to **assets/preload/data/characterList.txt** with the name of your character. Example:

```
bf
bf-pixel
bf-christmas
bf-car
gf
gf-christmas
dad
mom
mom-car
parents-christmas
spooky
pico
monster
monster-christmas
senpai
senpai-angry
spirit
newChar
```

Then, in **source/Character.hx** copy this code and paste it in the switch (curCharacter) statement
			```
case 'newChar':
	tex = Paths.getSparrowAtlas('peoples/DADDY_DEAREST', 'shared');
	frames = tex;
	animation.addByPrefix('idle', 'Dad idle dance', 30,false);
	animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
	animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
	animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
	animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

	addOffset('idle');
	addOffset("singUP", -6, 50);
	addOffset("singRIGHT", 0, 27);
	addOffset("singLEFT", -10, 10);
	addOffset("singDOWN", 0, -30);

	playAnim('idle');
    ```

Please ask your animator/xml creator for the names of the animations for each note/idle.

Then, in HealthIcon.hx, 
add the new health icon. Example:
```animation.add('spirit', [23, 23], 0, false, isPlayer);```


Then from there, build the game and open the debug menu.

Change the P2 variable to your new character.

BOOM!

(sorry i suck at )