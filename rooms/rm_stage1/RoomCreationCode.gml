global.tileset = [spr_block_1_big, spr_block_1_medium, spr_block_1_small, spr_semisolid_1];
game.alarm[1] = 1;
global.lateinit = function() {
	set_rooms(6, [
		"r", "l,r", "l", "", "", "",
		"u,l,d,r", "u,l,d,r", "u,l,d,r", "u,l,d,r", "u,l,d,r", "u,l,d,r",
		"u,l,d,r", "u,l,d,r", "u,l,d,r", "u,l,d,r", "u,l,d,r", "u,l,d,r",
		"u,d,r", "u,d,l", "d,l,r", "u,d,r", "u,d,l", "d,l,r",
		"u,l,r", "u,l,r", "u,l,r", "u,l,r", "u,l,r", "u,l,r",
		"d", "u", "u,d"
	], 15, [1, 2]);
	play_bgm(bgm_w1);
	show_title("The Spritefields", 5, c_lime);
	show_tutorial("Peeking", "Hold " + button_pretty(game.save.peek) + " along with your " + (game.save.peekwithaim ? "aim" : "movement") + " keys to peek at the next room. you can also attack while peeking.");
}