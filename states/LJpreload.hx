//a
import openfl.utils.Assets;
import openfl.utils.AssetCache;
import Sys;
import lime.app.Future;
import StringTools;
import haxe.io.Path;
import flixel.graphics.FlxGraphic;
import FreeplayState;
import PlayState;
import haxe.Json;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.text.FlxTextBorderStyle;
import Highscore;
import Song;
import Script;
import ScriptPack; // you fucking cant just do 'Script.ScriptPack' you gotta import them one by on
import ModSupport;
import sys.io.File;
import SongConf;
import flixel.math.FlxMath;
import sys.FileSystem;
import Note;


var maxTest:Int = 0;
var percentage:Float = 0;
var text:FlxText;

var preloadImages:Array<String> = [];
var preloadSounds:Array<String> = [];
var preloadMisc:Array<String> = [];
var preloadSongs:Array<String> = [];
var preloadCharacters:Array<String> = [];

var allThingsToPreload:Array<Dynamic> = [];

var noteScripts = {
    scripts: []
};

var otherScripts = {
    scripts: []
};

var daBar:FlxBar;

var configSong = Json.parse(File.getContent("mods/" + mod + "/song_conf.json"));
function create() {
    FlxG.camera.zoom = 1;

    for(s in configSong.songs) {
        if (s.name.toLowerCase() == PlayState_._SONG.song.toLowerCase()) {
            if (s.scripts != null) for (s in s.scripts) {
                if (!StringTools.contains(s, "stages/")) otherScripts.scripts.push(SongConf.getModScriptFromValue(mod, s));
            }
        }
    }
    
    if (PlayState_.isStoryMode) {
        for (songName in PlayState_.storyPlaylist) {
            addAutomatically(Std.string(songName));
        }
    } else {
        addAutomatically(PlayState_._SONG.song);
    }

    if (noteScripts.scripts.length > 0) {
        daNotes = new ScriptPack(noteScripts.scripts);
        daNotes.setVariable("super", superItems = {
            create: function() {
                for (item in [Paths.image('NOTE_assets_colored', 'shared'), Paths.splashes("splashes.png", "shared")])
                    if (!preloadMisc.contains(item)) preloadMisc.push(item);
            }
        });
        daNotes.setVariable("ljPreloadImages", function(arry:Array<String>) {
            for (item in arry) preloadImages.push(item);
        });
        daNotes.setVariable("ljPreloadSounds", function(arry:Array<String>) {
            for (item in arry) preloadSounds.push(item);
        });
        daNotes.setVariable("ljPreloadMisc", function(arry:Array<String>) {
            for (item in arry) preloadMisc.push(item);
        });
        for (s in daNotes.scripts) s.setScriptObject(this);
        daNotes.loadFiles();
        daNotes.executeFunc("ljPreloading");
    }
    
    if (otherScripts.scripts.length > 0) {
        daOthers = new ScriptPack(otherScripts.scripts);
        daOthers.setVariable("ljPreloadImages", function(arry:Array<String>) {
            for (item in arry) preloadImages.push(item);
        });
        daOthers.setVariable("ljPreloadSounds", function(arry:Array<String>) {
            for (item in arry) preloadSounds.push(item);
        });
        daOthers.setVariable("ljPreloadMisc", function(arry:Array<String>) {
            for (item in arry) preloadMisc.push(item);
        });
        daOthers.setVariable("ljPreloadCharacters", function(arry:Array<String>) {
            for (item in arry) {
                var charPath = Paths.getCharacterFolderPath(mod+":"+item);
                var split = charPath.split("mods/")[1].split("/");
                var data = Paths.getLibraryPathForce("characters/" + item + "/spritesheet.png", "mods/" + split[0]);
                preloadMisc.push(data);
            }
        });
        // daOthers.setVariable("ljPreloading", function(){});
        for (s in daOthers.scripts) s.setScriptObject(this);
        daOthers.loadFiles();
        daOthers.executeFunc("ljPreloading");
    }

    maxTest = preloadImages.length + preloadSounds.length + preloadSongs.length + preloadMisc.length;

    if (FlxG.sound.music != null) FlxG.sound.music.fadeOut(0.5, 0.25);
    for (item in [preloadImages, preloadSounds, preloadSongs, preloadMisc]) {
        for (e in item) allThingsToPreload.push(e);
    }

    coolUI();

    FlxGraphic.defaultPersist = true;
    preloadShit();
}

function addAutomatically(songName:String) {
    
    // var shitInFolders = FileSystem.readDirectory(Paths.get_modsPath()+"/"+mod+"/data/"+songName);
    // for (item in shitInFolders) {
    //     if (Path.extension(item) != ".hx") continue;
    //     otherScripts.scripts.push({path: mod + "/data/"+songName+"/"+Path.withExtension(item)});
    // }
    var songsData = Song.loadModFromJson(Highscore.formatSong(songName.toLowerCase(), PlayState_.storyDifficulty), PlayState_.songMod, songName.toLowerCase());
    var stageData = null;
    if (!Assets.exists(Paths.stage(songsData.stage))) {
        for (item in configSong.songs) {
            if (item.name != songName.toLowerCase()) continue;
            var stageLol = null;
            for (script in item.scripts) {
                if (StringTools.contains(script, "stages/")) {
                    if (Assets.exists(Paths.stage(script.split("stages/")[1])))
                        stageData = Json.parse(Assets.getText(Paths.stage(script.split("stages/")[1])));
                    break;
                }
            }
        }
    }
    else stageData = Json.parse(Assets.getText(Paths.stage(songsData.stage)));
    
    if (stageData != null) {
        for (item in stageData.sprites) {
            if (item.src == null || item.src == "") continue;
            if (!preloadImages.contains(item.src)) preloadImages.push(item.src);
        }
    }

    for (item in [songsData.player1, songsData.player2, songsData.player3]) {
        if (item == null) continue;
        var charPath = Paths.getCharacterFolderPath(mod+":"+item);
        var split = charPath.split("mods/")[1].split("/");
        var data = Paths.getLibraryPathForce("characters/" + item + "/spritesheet.png", "mods/" + split[0]);
        if (!preloadMisc.contains(data)) preloadMisc.push(data);
    }

    if (songsData.noteTypes != null) {
        for (daNotes in songsData.noteTypes) {
            if (StringTools.contains(daNotes, "Default Note")) {
                if (Assets.exists(Paths.getLibraryPathForce("notes/Default Note.hx", "mods/"+mod))) {
                    // The Note is probably overriden.
                    noteScripts.scripts.push({path: mod + "/notes/Default Note"});
                } else {
                    for (item in [Paths.image('NOTE_assets_colored', 'shared'), Paths.splashes("splashes.png", "shared")])
                        if (!preloadMisc.contains(item)) preloadMisc.push(item);
                }
            } else {
                var data = daNotes.split(":");
                if (data[1] == null) data = data[0];
                else data = data[1];
                noteScripts.scripts.push({path: mod + "/notes/" + data});
            }
        }       
    } else {
        for (item in [Paths.image('NOTE_assets_colored', 'shared'), Paths.splashes("splashes.png", "shared")])
            if (!preloadMisc.contains(item)) preloadMisc.push(item);
    }

    var instPath = Paths.modInst(songName, PlayState_.songMod, (PlayState_.storyDifficulty.toLowerCase() == "normal") ? "" : StringTools.replace(PlayState_.storyDifficulty.toLowerCase(), "-", " "));
    var vocalPath = Paths.modVoices(songName, PlayState_.songMod, (PlayState_.storyDifficulty.toLowerCase() == "normal") ? "" : StringTools.replace(PlayState_.storyDifficulty.toLowerCase(), "-", " "));
    if (!preloadSongs.contains(instPath)) {
        preloadSongs.push(instPath);
        if (vocalPath != null) preloadSongs.push(vocalPath);
    }
}

var doneStuff:Int = 0;
var customI:Int = 0;
function preloadShit() {
    var futureThread = new Future(function() {
        customI = 0;
        for (i in 0...preloadImages.length) {
            if (!FlxG.bitmap.checkCache(preloadImages[customI])) {
                FlxG.bitmap.add(Paths.image(preloadImages[customI]));
            }
            if (!Assets.cache.bitmapData.exists(preloadImages[customI])) {
                if (!Assets.exists(Path.withoutExtension(Paths.image(preloadImages[customI])) + ".xml")) {
                    Assets.getBitmapData(Paths.image(preloadImages[customI])); // this shit is so unstable its more unstable than Uranium.
                } else {
                    Assets.loadText(Path.withoutExtension(Paths.image(preloadImages[customI])) + ".xml");
                }
            }

            doneStuff++;
            customI++;
        }
        customI = 0;
        for (i in 0...preloadSounds.length) {
            FlxG.sound.cache(Paths.sound(preloadSounds[customI]));
            if (Assets.exists(Paths.sound(preloadSounds[customI]))) {
                Assets.getMusic(Paths.sound(preloadSounds[customI]));
            }

            doneStuff++;
            customI++;
        }

        customI = 0;
        for (i in 0...preloadSongs.length) {
            FlxG.sound.cache(preloadSongs[customI]);
            if (Assets.exists(preloadSongs[customI])) {
                Assets.getMusic(preloadSongs[customI]);
            }

            doneStuff++;
            customI++;
        }

        customI = 0;
        for (i in 0...preloadMisc.length) {
            if (!FlxG.bitmap.checkCache(preloadMisc[customI])) {
                FlxG.bitmap.add(preloadMisc[customI]);
            }
            if (!Assets.cache.bitmapData.exists(preloadMisc[customI])) {
                if (!Assets.exists(Path.withoutExtension(preloadMisc[customI]) + ".xml")) {
                    Assets.getBitmapData(preloadMisc[customI]); // this shit is so unstable its more unstable than Uranium.
                } else {
                    Assets.loadText(Path.withoutExtension(preloadMisc[customI]) + ".xml");
                }
            }

            doneStuff++;
            customI++;
        }
    }, true).onComplete(function() {
		FlxGraphic.defaultPersist = false;
        if (FlxG.sound.music != null) FlxG.sound.music.fadeOut(1, 0);
        CoolUtil.playMenuSFX(1);
        var oke:FlxSprite = new FlxSprite().makeGraphic(FlxG.width+5,FlxG.height+5, 0xFF000000);
        oke.scrollFactor.set();
        oke.updateHitbox();
        oke.screenCenter();
        oke.alpha = 0.0001;
        add(oke);
        FlxTween.tween(oke, {alpha: 1}, 1, {startDelay: 1, ease:FlxEase.quadInOut, onComplete: function(twn) {
            FlxG.switchState(new PlayState());
        }});
    });
}
function update(elapsed:Float) {
    if (daBar != null) daBar.value = FlxMath.lerp(daBar.value, percentage, elapsed*5);
    if (Math.fround(percentage >= 100)) return;
    percentage = Math.fround((doneStuff - 0) / (maxTest - 0) * 100);

    var display = "";

    if (allThingsToPreload[doneStuff-1] != null) display = allThingsToPreload[doneStuff-1].split("assets");
    if (display[1] != null) display = display[1];
    else display = display[0];

    text.text = (allThingsToPreload[doneStuff-1] != null) ? "Loading... | " + display + " | " + percentage + "%": "Loading...";
    text.updateHitbox();
    text.screenCenter();
    text.y = (FlxG.height / 2) + text.height * 6;
}

function coolUI() {
    
    var bg:FlxSprite = new FlxSprite(0,0,Paths.image("loading/menuBGYoshiCrafter"));
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.scrollFactor.set();
    bg.alpha = 1;
    add(bg);


    text = new FlxText(0,0,0, "Test", 20);
    text.screenCenter();
    text.y = (FlxG.height / 2) + text.height * 6;
    text.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
    text.scrollFactor.set();
    add(text);
    
    daBar = new FlxBar(0,0, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(FlxG.width/1.5), 20);
    // daBar.createFilledBar(0xFF242424, 0xFFFF0000);
    daBar.createGradientEmptyBar([0xFF0d0331, 0xff2a0b99], 1, 90, true, 0xFF000000);
    daBar.createGradientFilledBar([0xFF2F1364, 0xff4f1bb1], 1, 90, true, 0xFF000000);
    daBar.updateHitbox();
    daBar.screenCenter();
    daBar.y = FlxG.height - daBar.height - 50;
	daBar.setRange(0, 100);
    daBar.scrollFactor.set();
    add(daBar);
}