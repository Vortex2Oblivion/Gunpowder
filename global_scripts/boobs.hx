function createPost(){
    for (note in PlayState.unspawnNotes){
        switch(note.noteData % PlayState.song.keyNumber) {
            case 0:
                note.splashColor = 0xEE846C;
            case 1:
                note.splashColor = 0xDE2476;
            case 2:
                note.splashColor = 0x7E1EB1;
            case 3:
                note.splashColor = 0x5B819A;
        }
    }
}