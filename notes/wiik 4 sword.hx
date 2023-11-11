enableRating = true;

// enableMiss(true);

/*var wiik4_sprites:Map<String, FlxSprite> = [];

var wiik4:Array<FlxSprite> = [];


function getUnspawnedNoteStrumtime(id:Int) {
    return PlayState.instance.unspawnNotes[id].strumTime;
}

function getUnspawnedNoteMustPress(id:Int){
    return PlayState.instance.unspawnNotes[id].mustPress;
}

function createPost() {
    var noteCount = PlayState.instance.unspawnNotes.length;

    for (i in 0...noteCount - 1 ){
        var st = getUnspawnedNoteStrumtime(i)
        if(getUnspawnedNoteMustPress(i)){
            wiik4.push()
        }
    }
}
function noteSpawn(note) {
    new FlxSprite(PlayState.boyfriend.x - 300, PlayState.boyfriend.y).loadGraphic(Paths.image("MattSlash"));
    trace("note spawned");
}
  
PlayState.notes.memberAdded.add(noteSpawn);
*/

function create() {

    note.frames = Paths.getSparrowAtlas("Wiik4Sword");
 
    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "left0");
            note.animation.addByPrefix('holdend', "left hold0");
            note.animation.addByPrefix('holdpiece', "left hold end0");
        case 1:
            note.animation.addByPrefix('scroll', "down0");
            note.animation.addByPrefix('holdend', "down hold0");
            note.animation.addByPrefix('holdpiece', "down hold end0");
        case 2:
            note.animation.addByPrefix('scroll', "up0");
            note.animation.addByPrefix('holdend', "up hold0");
            note.animation.addByPrefix('holdpiece', "up hold end0");
        case 3:
            note.animation.addByPrefix('scroll', "right0");
            note.animation.addByPrefix('holdend', "right hold0");
            note.animation.addByPrefix('holdpiece', "right hold end0");
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
}
function onMiss(note:Int){
    PlayState.health -= 1;
}