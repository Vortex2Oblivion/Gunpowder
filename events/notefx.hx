function fx(){
    if (PlayState.boyfriend.arrowColors == null){
        for (note in PlayState.unspawnNotes){
            switch(note.noteData % PlayState.song.keyNumber) {
                case 0:
                    note.splashColor = 0xFF000000;
                    
                case 1:
                    note.splashColor = 0xFF000000;
                    
                case 2:
                    note.splashColor = 0xFF000000;
                    
                case 3:
                    note.splashColor = 0xFF000000;
                    
            }
        }
        for (note in PlayState.notes.members){
            switch(note.noteData % PlayState.song.keyNumber) {
                case 0:
                    note.splashColor = 0xFF000000;
                    
                case 1:
                    note.splashColor = 0xFF000000;
                    
                case 2:
                    note.splashColor = 0xFF000000;
                    
                case 3:
                    note.splashColor = 0xFF000000;
                    
            }
        }
    }
}