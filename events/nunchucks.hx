//fuck you yce


function ljPreloading() {
    ljPreloadImages(["Wiik_2_Echo"]);
    ljPreloadImages(["MattStand_Attack"]);
    ljPreloadImages(["MattSlash"]);
    ljPreloadImages(["EchoGlove"]);
    ljPreloadImages(["WhiteWiik_2_Echo"]);
    ljPreloadImages(["WhiteMattStand_Attack"]);
    ljPreloadImages(["WhiteMattSlash"]);
    ljPreloadImages(["WhiteEchoGlove"]);
}


function wiik2(?num:Int = 1) {
    if(num == null)
        num = 1;
    for (i in 0...num){
        var wiik2 = new FlxSprite(PlayState.boyfriend.x - 1000, PlayState.boyfriend.y - 700 + FlxG.random.int(-150,100));
        wiik2.frames = Paths.getSparrowAtlas("Wiik_2_Echo");
        wiik2.setGraphicSize(Std.int(wiik2.width * 1.5));
        wiik2.animation.addByPrefix("attack", "attack", 60, false);
        wiik2.animation.play("attack", true);
        PlayState.add(wiik2);
        var glove = new FlxSprite(0,0);
        glove.frames = Paths.getSparrowAtlas("EchoGlove");
        glove.animation.addByPrefix("echoglove", "echoglove", 24, false);
        glove.visible = false;
        glove.angle = 45;
        PlayState.add(glove);
        wiik2.animation.callback = function (animName, frameNum, frameIndex) {
            if(frameNum == 16){
                glove.x = wiik2.x + wiik2.width - 250;
                glove.y = wiik2.y + 100;
                glove.visible = true;
                glove.animation.play("echoglove", true);
                var ang = Math.atan2(glove.x - PlayState.boyfriend.x, glove.y-PlayState.boyfriend.y + 250);
                ang = ang / (Math.PI/180);
                glove.angle = ang+155;
                FlxTween.tween(glove, {x: PlayState.boyfriend.x, y: PlayState.boyfriend.y + 250 }, 0.1, {ease: FlxEase.linear, onComplete: function(){
                    PlayState.remove(glove);
                    glove.destroy();
                    glove.kill();
                }});
            }
        }
        wiik2.animation.finishCallback = function (animName){
            if (animName == "attack"){
                PlayState.remove(wiik2);
                wiik2.destroy();
                wiik2.kill();
            }
        }
    }
}

function wiik3(?num:Int = 1) {
    if(num == null)
        num = 1;
    for (i in 0...num){
        var wiik3 = new FlxSprite(PlayState.boyfriend.x - 500 + FlxG.random.int(-50,50), PlayState.boyfriend.y - 100+40 + FlxG.random.int(-20,20));
        wiik3.frames = Paths.getSparrowAtlas("MattStand_Attack");
        wiik3.setGraphicSize(Std.int(wiik3.width * 1.5));
        wiik3.animation.addByPrefix("attack", "attack", 24, false);
        wiik3.animation.play("attack", true);
        PlayState.add(wiik3);
        wiik3.animation.finishCallback = function (animName){
            if (animName == "attack"){
                PlayState.remove(wiik3);
                wiik3.destroy();
                wiik3.kill();
            }
        }
    }
}

function wiik4(?num:Int = 1) {
    if(num == null)
        num = 1;
    for (i in 0...num){
        var wiik4 = new FlxSprite(PlayState.boyfriend.x - 1000 + FlxG.random.int(-100,150), PlayState.boyfriend.y - 355 + FlxG.random.int(-20,20));
        wiik4.frames = Paths.getSparrowAtlas("MattSlash");
        wiik4.setGraphicSize(Std.int(wiik4.width * 1.5));
        wiik4.animation.addByPrefix("mattslash", "mattslash", 24, false);
        wiik4.animation.play("mattslash", true);
        PlayState.add(wiik4);
        wiik4.animation.finishCallback = function (animName){
            if (animName == "mattslash"){
                PlayState.remove(wiik4);
                wiik4.destroy();
                wiik4.kill();
            }
        }
    }
}

function wiik2w(?num:Int = 1) {
    if(num == null)
        num = 1;
    for (i in 0...num){
        var wiik2 = new FlxSprite(PlayState.boyfriend.x - 1000 + FlxG.random.int(-100,150), PlayState.boyfriend.y - 700 + FlxG.random.int(-20,20));
        wiik2.frames = Paths.getSparrowAtlas("WhiteWiik_2_Echo");
        wiik2.setGraphicSize(Std.int(wiik2.width * 1.5));
        wiik2.animation.addByPrefix("attack", "attack", 60, false);
        wiik2.animation.play("attack", true);
        PlayState.add(wiik2);
        var glove = new FlxSprite(0,0);
        glove.frames = Paths.getSparrowAtlas("WhiteEchoGlove");
        glove.animation.addByPrefix("echoglove", "echoglove", 24, false);
        glove.visible = false;
        glove.angle = 45;
        PlayState.add(glove);
        wiik2.animation.callback = function (animName, frameNum, frameIndex) {
            if(frameNum == 16){
                glove.x = wiik2.x + wiik2.width - 250;
                glove.y = wiik2.y + 100;
                glove.visible = true;
                glove.animation.play("echoglove", true);
                var ang = Math.atan2(glove.x - PlayState.boyfriend.x, glove.y-PlayState.boyfriend.y + 250);
                ang = ang / (Math.PI/180);
                glove.angle = ang+155;
                FlxTween.tween(glove, {x: PlayState.boyfriend.x, y: PlayState.boyfriend.y + 250 }, 0.1, {ease: FlxEase.linear, onComplete: function(){
                    PlayState.remove(glove);
                    glove.destroy();
                    glove.kill();
                }});
            }
        }
        wiik2.animation.finishCallback = function (animName){
            if (animName == "attack"){
                PlayState.remove(wiik2);
                wiik2.destroy();
                wiik2.kill();
            }
        }
    }
}

function wiik3w(?num:Int = 1) {
    if(num == null)
        num = 1;
    for (i in 0...num){
        var wiik3 = new FlxSprite(PlayState.boyfriend.x - 500 + FlxG.random.int(-50,50), PlayState.boyfriend.y - 100+40 + FlxG.random.int(-20,20));
        wiik3.frames = Paths.getSparrowAtlas("WhiteMattStand_Attack");
        wiik3.setGraphicSize(Std.int(wiik3.width * 1.5));
        wiik3.animation.addByPrefix("attack", "attack", 24, false);
        wiik3.animation.play("attack", true);
        PlayState.add(wiik3);
        wiik3.animation.finishCallback = function (animName){
            if (animName == "attack"){
                PlayState.remove(wiik3);
                wiik3.destroy();
                wiik3.kill();
            }
        }
    }
}

function wiik4w(?num:Int = 1) {
    if(num == null)
        num = 1;
    for (i in 0...num){
        var wiik4 = new FlxSprite(PlayState.boyfriend.x - 750 + FlxG.random.int(-100,150), PlayState.boyfriend.y - 355 + FlxG.random.int(-20,20));
        wiik4.frames = Paths.getSparrowAtlas("WhiteMattSlash");
        wiik4.setGraphicSize(Std.int(wiik4.width * 1.5));
        wiik4.animation.addByPrefix("mattslash", "mattslash", 24, false);
        wiik4.animation.play("mattslash", true);
        PlayState.add(wiik4);
        wiik4.animation.finishCallback = function (animName){
            if (animName == "mattslash"){
                PlayState.remove(wiik4);
                wiik4.destroy();
                wiik4.kill();
            }
        }
    }
}