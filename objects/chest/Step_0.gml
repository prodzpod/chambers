if (game.gameSpeed == 0) return;
if (instance_exists(player)) {
	var _x = x - pmod(x, 480);
	var _y = y - pmod(y, 270);
	if (collision_rectangle(_x, _y, _x + 480, _y + 270, player, false, true) != noone) {
		if (collision_rectangle(_x, _y, _x + 480, _y + 270, enemy, false, true) == noone) {
			if (locked) { locked = false; play_sfx(sfx_hat); }
			else if (random(1) < 0.1) particle_spawn(1, x, y)
		} else locked = true;
	}
	else if (locked) locked = false;
	// open
	if (!locked) {
		var inst = instance_place(x, y, bullet)
		if (hold > 0) hold -= delta_time / 1000000;
		if (inst != noone && inst.friendly && hold <= 0) {
			particle_spawn(16, x, y);
			screen_shake(3, 0.5);
			play_sfx(sfx_chime);
			if (!is_undefined(loot) && loot == 0) { // spawn WISH
				var z = instance_create_depth(0, 0, 0, wish);
				z.ch = self;
			} else {
				if (game.weaponroll <= 0 || random(1) < 0.3) {
					game.weaponroll = 3;
					if (is_undefined(loot)) {
						var eligible = [];
						for (var i = 0; i < array_length(game.WEAPON); i++) {
							var spawns = struct_default(game.WEAPON[i], "spawnsin", game.DEFAULT_WEAPON);
							if (array_contains(spawns, room)) array_push(eligible, i);
						}
						loot = array_random(eligible);
						if (random(1) < 0.1) loot *= -1;
					}
					with (instance_create_depth(x, y - 8, -1, drops)) {
						image_index = abs(other.loot);
						image_blend = sign(other.loot) == 1 ? c_white : c_yellow;
						yspeed = -400;
						if (instance_exists(player)) {
							player.nopickup = self;
							player._nopickup = 0.5;
						}
					}
				} else {
					game.weaponroll--;
					for (var k = 0; k < rolls[$ room_get_name(room)]; k++) {
						with (instance_create_depth(x, y - 8, -1, item)) {
							type = irandom(8) + 1;
							if (random(1) < (1 / max(1, game.run.hp))) type = 0; // heart get more frequent on lower hp
							yspeed = -400;
							if (instance_exists(player)) {
								player.nopickup = self;
								player._nopickup = 0.5;
							}
						}					
					}
				}
				instance_destroy();
			}
		}
	}
}
image_blend = locked ? c_gray : c_white;