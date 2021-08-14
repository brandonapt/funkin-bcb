# Building the Game

So, you wanna build BCB. Its easy.

THIS IS FOR BUILDING THE GAME TO MAKE A MOD. IF YOU JUST WANT TO PLAY, DOWNLOAD IT FROM GITHUB RELEASES.

Prerequirements:
- A computer running Windows 10 or Linux (idk anything about mac)
- 10 gigabytes of storage.

### Installing Haxe 4.1.5 and HaxeFlixel.

First off, download Haxe off of https://haxe.org/download/version/4.1.5/ and follow the instructions to install Haxe 4.1.5. Do not download 4.2+ because of something to do with gits or something idk.

Next, go to https://git-scm.com and download git for your OS.

Then, open up command prompt and run these commands:

```
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib run flixel-tools setup
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib install actuate
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git extension-webm https://github.com/GrowtopiaFli/extension-webm
lime rebuild extension-webm <windows, macos, linux>
```

Then, restart your computer.

### Windows-only dependencies (Only for building to Windows. Building HTML5 does not require this)

If you are planning to build for Windows, you also need to install Visual Studio 2019. While installing it, don’t click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:


    MSVC v142 - VS 2019 C++ x64/x86 build tools
    MSVC v141 - VS 2017 C++ x64/x86 build tools
    Windows SDK (10.0.17763.0)
    C++ Profiling tools
    C++ CMake tools for windows
    C++ ATL for v142 build tools (x86 & x64)

this is what most of the storage in the 10 gb goes to.

Next, still in CMD, run ```cd Desktop``` then,

```
git clone https://github.com/brandoge91/funkin-bcb.git
```

Then, run ```cd funkin-bcb```

Once in that folder, do all your coding and such, and then run this command.

```lime test windows```

your files will be sent to *export/release/windows/bin*

happy funkin!

