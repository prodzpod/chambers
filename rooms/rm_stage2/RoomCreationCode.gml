global.tileset = [spr_block_2_big, spr_block_2_medium, spr_block_2_small, spr_semisolid_2];
game.alarm[1] = 1;
global.lateinit = function() {
	set_rooms(6, [
		"u", "d", "d", "", "", "",
		"u,d", "u,d", "u,d", "u,d", "u,d", "u,d", 
		"u,d", "u,d", "u,d", "u,d", "u,d", "u,d", 
		"u,d,l,r", "u,d,l,r", "u,d", "u,d,l", "u,d,r", "u,d", 
		"u,d", "u,d", "u,d", "u,d,l", "u,d,r", "u,d", 
		"u", "d", "u", "u"
	], 20, [1, 2]);
	play_bgm(bgm_w2);
	show_title("The Tower", 5, make_color_rgb(200, 200, 255));
}