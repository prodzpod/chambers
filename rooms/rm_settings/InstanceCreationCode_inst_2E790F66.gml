text = "Hit 10 times to RESET SAVE";
global.temp = 0;
onclick = function() {
	global.temp++;
	if (global.temp == 10) {
		game.save = json_parse(json_stringify(game.DEFAULT_SAVE));
		room_goto(rm_character);
	}
}