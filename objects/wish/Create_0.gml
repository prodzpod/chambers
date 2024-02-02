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
		var it = -1;
		switch (string_lower(string_lettersdigits(s))) {
			case "health": it = 0; break;
			case "shield": it = 1; break;
			case "immunity": it = 2; break;
			case "repair": it = 3; break;
			case "jump": it = 4; break;
			case "speed": it = 5; break;
			case "mystery": it = 6; break;
			case "multishot": it = 7; break;
			case "critical": it = 8; break;
			case "damage": it = 9; break;
		}
		var weapon = -1;
		if (s != "") weapon = array_find_index(game.WEAPON, function(x) { return string_lower(string_lettersdigits(global.temp)) == string_lower(string_lettersdigits(struct_default(x, "name", game.DEFAULT_WEAPON))); });
		if (it != -1) {
			screen_shake(3, 1.5);
			particle_spawn(32, x, y);
			with (instance_create_depth(x, y - 8, -1, item)) {
				type = it;
				xspeed = -400;
				yspeed = -200;
				player.nopickup = self;
				player._nopickup = 1;
			}
			with (instance_create_depth(x, y - 8, -1, item)) {
				type = it;
				xspeed = 200;
				yspeed = -300;
				player.nopickup = self;
				player._nopickup = 1;
			}
			with (instance_create_depth(x, y - 8, -1, item)) {
				type = it;
				yspeed = -400;
				player.nopickup = self;
				player._nopickup = 1;
			}
			with (instance_create_depth(x, y - 8, -1, item)) {
				type = it;
				xspeed = 200;
				yspeed = -300;
				player.nopickup = self;
				player._nopickup = 1;
			}
			with (instance_create_depth(x, y - 8, -1, item)) {
				type = it;
				xspeed = 400;
				yspeed = -200;
				player.nopickup = self;
				player._nopickup = 1;
			}
			if (global.parent.ch != noone && instance_exists(global.parent.ch)) instance_destroy(global.parent.ch);
			play_sfx(sfx_snare);
			play_sfx(sfx_chime);			
		}
		else if (weapon == -1) {
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
		game.gameSpeed = 1;
		instance_destroy(global.parent);
		instance_destroy(self);
	};
}