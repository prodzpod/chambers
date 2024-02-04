text = "Cancel"
disabled = (game.save.name == "");
onclick = function() {
	game.gameSpeed = 1;
	room_goto(rm_title);
}