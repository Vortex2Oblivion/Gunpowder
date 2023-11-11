//a
import Conductor;
import PlayState;
import MusicBeatState;
import Reflect;
import StringTools;
import openfl.utils.Assets;
import openfl.utils.AssetCache;
import openfl.system.System;
var continueNormal:Bool = false;
var daLogo:FlxSprite;
var madeWith:FlxText;
var beforeVol = FlxG.sound.volume;

var newBG:FlxSprite;
function createPost() {
    if (save.data.yceModJam == null) {
        save.data.yceModJam = false;
        save.flush();
    }
    daLogo = new FlxSprite(0,0);
    daLogo.scale.set(0.35,0.35);
    daLogo.frames = Paths.getSparrowAtlas('yceModJam/yceJam');
    daLogo.animation.addByPrefix('idle', '', 24, true);
    daLogo.animation.play('idle', true);
    daLogo.antialiasing = EngineSettings.antialiasing;
    daLogo.scrollFactor.set();
    daLogo.updateHitbox();
    daLogo.screenCenter();

    newBG = new FlxSprite(0,0, Paths.image("yceModJam/coolModJamBG"));
    newBG.scrollFactor.set();
    newBG.setGraphicSize(FlxG.width, FlxG.height);
    newBG.updateHitbox();
    newBG.screenCenter();
    newBG.x = 0 - newBG.width - 15;

    madeWith = new FlxText(0,0,0, "Made during the YCE ModJam", 32);
    madeWith.font = Paths.font("yceModJam/memphis.ttf");
    madeWith.scrollFactor.set();
    madeWith.updateHitbox();
    madeWith.screenCenter(FlxAxes.X);
    madeWith.y = daLogo.y + daLogo.height - madeWith.height;
    
    details = new FlxText(0,0,0, "Happy 3rd Birthday YCE", 32);
    details.font = Paths.font("yceModJam/memphis.ttf");
    details.scrollFactor.set();
    details.updateHitbox();
    details.screenCenter(FlxAxes.X);
    details.y = madeWith.y + details.height + 5;
    
    credGroup.insert(credGroup.members.indexOf(state.blackScreen)+1, madeWith);
    credGroup.insert(credGroup.members.indexOf(state.blackScreen)+1, details);
    credGroup.insert(credGroup.members.indexOf(state.blackScreen)+1, daLogo);
    credGroup.insert(credGroup.members.indexOf(madeWith)+1, newBG);
    daLogo.alpha = 0.0001;
    madeWith.alpha = 0.0001;
    details.alpha = 0.0001;


    // why == false? it has a chance to not work when if (save.data.yceModJam)
    if (save.data.yceModJam == false) startVideoIntro();
    else {
        newBG.x = 0;
        continueNormal = true;
        Conductor.songPosition = 0;
        FlxG.sound.music.time = 0;
    }
    // if you don't want to play the video (i'd reccomend you do) just do:
    // doYceModJamIntro();
}

function startVideoIntro() {
    FlxG.sound.music.stop();
    var mFolder = Paths_.modsPath;
    var path = mFolder + "\\" + mod + "\\images\\yceModJam\\" + "intro.mp4"; // intro
    FlxG.sound.volume = 1;
    videoSprite = MP4Video.playMP4(path, function() {
        state.remove(videoSprite);
        FlxG.sound.volume = beforeVol;
        doYceModJamIntro();
    }, false, FlxG.width, FlxG.height);
    videoSprite.scrollFactor.set();
    state.add(videoSprite);
}


// YOU CAN EDIT THIS FUNCTION!!!
function doYceModJamIntro() {
    FlxG.sound.music.stop();
    new FlxTimer().start(1, function(timer:FlxTimer) {
        FlxTween.tween(daLogo, {alpha: 1}, 0.5, {ease:FlxEase.quintIn});
        FlxG.sound.play(Paths.sound('confirmMenu'), 1, false, null, true);
        new FlxTimer().start(1, function(timer:FlxTimer) {
            FlxTween.tween(daLogo, {y: daLogo.y - madeWith.height - 25}, 2, {ease:FlxEase.circInOut});
            madeWith.y += madeWith.height + 25;
            FlxTween.tween(madeWith, {alpha: 1, y: madeWith.y - madeWith.height - 25}, 2, {ease:FlxEase.circInOut, startDelay: 0.15});
            FlxTween.tween(details, {alpha: 1}, 1, {ease:FlxEase.quadIn, startDelay: 3});
            // EDIT HERE IF YOU WANT TO
            FlxTween.tween(newBG, {x: 0}, 1.25, {ease:FlxEase.quintOut, startDelay: 6, onComplete: function() {
                continueNormal = true;
                Conductor.songPosition = 0;
                FlxG.sound.music.time = 0;
                CoolUtil.playMenuMusic(true);
                save.data.yceModJam = true;
                save.flush();
            }});
        });
    });
}
/* YOU AT LEAST NEED THIS IN ORDER TO RESUME THE NORMAL TITLESTATE FUNCTION!!! vvvvvv
    FlxTween.tween(newBG, {x: 0}, 2, {ease: FlxEase.quintOut, onComplete: function() {
        continueNormal = true;
        Conductor.songPosition = 0;
        FlxG.sound.music.time = 0;
        CoolUtil.playMenuMusic(true);
        save.data.yceModJam = true;
        save.flush();
    }});
*/

function update(elapsed:Float) {
    if (!continueNormal) {
        Conductor.songPosition = 0;
        FlxG.sound.music.time = 0;
        return;
    }
    var lerp = FlxMath.lerp(1.05, 1, FlxEase.cubeOut(curDecBeat % 1));
    newBG.scale.set(lerp,lerp);
}
function textShit(beat:Int) {
    if (!continueNormal) return false; // prevent default behaviour
}
function onSkipIntro() {
    if (!continueNormal) {
        skippedIntro = true;
        return false;
    }
}
function onSkipIntroPost() {
    if (!continueNormal) skippedIntro = false;
}


// Base game stuff, edit here lol
var crafterEngineLogo:FlxSprite = null;
var gfDancing:FlxSprite = null;

function create() {
    gfDancing = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
    gfDancing.frames = Paths.getSparrowAtlas('titlescreen/gfDanceTitle');
    gfDancing.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
    gfDancing.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
    gfDancing.animation.play('danceLeft', true);
    gfDancing.antialiasing = true;
    add(gfDancing);

    crafterEngineLogo = new FlxSprite(-50, -35);
    crafterEngineLogo.frames = Paths.getSparrowAtlas('titlescreen/logoBumpin');
    crafterEngineLogo.antialiasing = true;
    crafterEngineLogo.animation.addByPrefix('bump', 'logo bumpin', 24);
    crafterEngineLogo.animation.play('bump');
    crafterEngineLogo.updateHitbox();
    crafterEngineLogo.scale.x = crafterEngineLogo.scale.y = 0.95;
    add(crafterEngineLogo);

    if (!MusicBeatState.__firstStateLoaded) {
		MusicBeatState.__firstStateLoaded = true; // this is an unused variable in YCE, so we just make it our custom "Static" variable lmao
        FlxG.signals.postUpdate.add(function() {
            if ((Std.isOfType(FlxG.game._requestedState, PlayState_) && FlxG.game._requestedState != FlxG.state)
                && !Std.isOfType(FlxG.state, ModState)
                && !(Std.isOfType(FlxG.state, PlayState_))) {
                if (Assets.exists(Paths.file("states/LJpreload.hx"))) FlxG.switchState(new ModState("LJpreload"));
            }
        });
        FlxG.signals.preStateCreate.add(function(state) {
            if ((Std.isOfType(state, ModState) && Reflect.field(state, "_scriptName") == "LJpreload") || Std.isOfType(state, PlayState_)) return;

            if (FlxG.bitmap._cache == null) {
                FlxG.bitmap._cache = new Map();
                return;
            }
        
            for (key in FlxG.bitmap._cache.keys()) {
                var obj = FlxG.bitmap.get(key);
                var isFileAsset = StringTools.contains(obj.key, "assets/");
                if (obj != null && (!obj.persist || isFileAsset)) {
                    FlxG.bitmap.removeKey(key);
                    obj.destroy();
                }
            }
            for (i in 0...5) System.gc();
            Assets.cache.clearExceptArray([]);
            Assets.cache.clear("");
        });
	}
}

function beatHit() {
    if (gfDancing != null) gfDancing.animation.play((gfDancing.animation.curAnim.name == "danceLeft") ? "danceRight" : "danceLeft");
}