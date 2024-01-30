game.gameSpeed = 0;
var z = instance_create_depth(game.cameraX + 240, game.cameraY + 135, -10, generic_input);
ch = noone;
global.parent = self;
with (z) {
	image_xscale = 48;
	image_yscale = 3.6666;
	placeholder = "Wish for anything...";
	oninput = function(s) { 
		global.temp = s;
		var weapon = -1;
		if (s != "") weapon = array_find_index(game.WEAPON, function(x) { return string_lower(string_lettersdigits(global.temp)) == string_lower(string_lettersdigits(struct_default(x, "name", game.DEFAULT_WEAPON))); });
		game.gameSpeed = 1;
		if (weapon == -1) {
			show_tooltip("It fizzles...", 1);
			play_sfx(sfx_afuche);
		} else {
			screen_shake(3, 1.5);
			particle_spawn(32, x, y);
			with (instance_create_depth(x, y - 8, -1, drops)) {
				image_index = weapon;
				image_blend = c_yellow;
				yspeed = -400;
				player.nopickup = self;
				player._nopickup = 1;
			}
			if (global.parent.ch != noone && instance_exists(global.parent.ch)) instance_destroy(global.parent.ch);
			play_sfx(sfx_snare);
			play_sfx(sfx_chime);
		}
		instance_destroy(global.parent);
		instance_destroy(self);
	};
}