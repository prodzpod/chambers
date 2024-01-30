global.tileset = [spr_block_1_big, spr_block_1_medium, spr_block_1_small, spr_semisolid_1];
game.alarm[1] = 1;
global.lateinit = function() {
	set_rooms(3, [
		"r", "l,r", "l",
		"l", "r", "u",
		"l,r", "l,r", "l,r",
		"u,r", "u,l", "u,l,r",
		"d,l,r", "u,d,r", "u,d,l",
		"d,l", "d,r", "d,l,r",
		"u,d,l", "u,d,r", "u,d,l,r"
	], 10, [1, 2]);
	play_bgm(bgm_w1);
}