enableRating = true;

// enableMiss(true);

function create() {
    note.frames = Paths.getSparrowAtlas("VoiidBullet");

    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "purple0");
            note.animation.addByPrefix('holdend', "pruple end hold");
            note.animation.addByPrefix('holdpiece', "purple hold piece");
        case 1:
            note.animation.addByPrefix('scroll', "blue0");
            note.animation.addByPrefix('holdend', "blue hold end");
            note.animation.addByPrefix('holdpiece', "blue hold piece");
            note.offset.set(50, 0);
        case 2:
            note.animation.addByPrefix('scroll', "green0");
            note.animation.addByPrefix('holdend', "green hold end");
            note.animation.addByPrefix('holdpiece', "green hold piece");
        case 3:
            note.animation.addByPrefix('scroll', "red0");
            note.animation.addByPrefix('holdend', "red hold end");
            note.animation.addByPrefix('holdpiece', "red hold piece");
    }
    note.setGraphicSize(Std.int(note.width * 0.7));
    note.updateHitbox();
    note.antialiasing = true;
    note.splashColor = 0xFF800080;

    note.animation.play("scroll");
    if (note.isSustainNote) {
        if (note.prevNote != null)
            if (note.prevNote.animation.curAnim.name == "holdend")
                note.prevNote.animation.play("holdpiece");
        note.animation.play("holdend");
    }
}

function onPlayerHit(noteData) {
    PlayState.scripts.executeFunc("caBurst");
    PlayState.scripts.executeFunc("makeTracer");
    switch(noteData) {
        case 0:
            playBFsAnim("dodgeLEFT", true);
        case 1:
            playBFsAnim("dodgeDOWN", true);
        case 2:
            playBFsAnim("dodgeUP", true);
        case 3:
            playBFsAnim("dodgeRIGHT", true);
    }
    dad.animation.play("shoot",true);
}
function onMiss(note:Int){
    PlayState.health -= 0.5;
    dad.animation.play("shoot",true);
    PlayState.scripts.executeFunc("makeTracer");
    PlayState.scripts.executeFunc("addBleedTime");
}