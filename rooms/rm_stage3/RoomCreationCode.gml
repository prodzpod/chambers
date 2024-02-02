global.tileset = [spr_block_3_big, spr_block_3_medium, spr_block_3_small, spr_semisolid_3];
game.alarm[1] = 1;
global.lateinit = function() {
	set_rooms(4, [
		"l,r", "l,r", "l,r", "",
		"l,r", "l,r", "l,r", "l,r", 
		"l,r", "l,r", "l,r", "l,r"
	], 5, [1, 2]);
	play_bgm(bgm_w3);
}