function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	GameOverSubstate.char = "Gunpowder:taro-wiik100-dead";
}