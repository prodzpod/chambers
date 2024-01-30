/// @description init
event_inherited();
alarm[0] = 1;
color_hair = game.save.color_hair;
color_skin = game.save.color_skin;
color_shirt = game.save.color_shirt;
color_arms = game.save.color_arms;
color_legs = game.save.color_legs;
color_legr = game.save.color_legs;
COLOR_LEGS_SHADE = 0.5;

type_hair = game.save.type_hair;
type_cosmetic = game.save.type_cosmetic;

face = 1;
stale = 1;

// stats
_jump = 1;
_reload = 0;
_aim = 0;
_recoil = 0;

_immunity = 0;
_immunityBlink = false;

nopickup = noone;
_nopickup = 0;

usenum = 0;

// movement
onstep = function(t) {
	var hInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	var vInput = keyboard_check(vk_space);
	var atkInput = mouse_check_button(mb_left);
	var switchInput = mouse_check_button_pressed(mb_right);
	if (keyboard_check(vk_shift)) {
		hInput = 0; vInput = 0; atkInput = 0;
	}
	xspeed = hInput * game.run.move;
	if (vInput && _jump) {
		yspeed = -game.run.jump;
		_jump -= 1;
	}
	if (hInput != 0) face = hInput;
	if (switchInput) {
		stale = 1;
		var drop = array_shift(game.run.inventory);
		if (array_length(game.run.inventory) == 0) {
			array_push(game.run.inventory, 0);
			if (drop == 0) return;
			array_push(game.run.durability, 0);
		}
		show_tooltip(stat("name"), 1, game.run.inventory[0] < 0 ? c_yellow : c_white);
		with (instance_create_depth(xcenter, ycenter, -1, drops)) {
			image_index = abs(drop);
			image_blend = sign(drop) == 1 ? c_white : c_yellow;
			xspeed = game.run.jump * dcos(-other._aim);
			yspeed = game.run.jump * dsin(-other._aim);
			_durability = array_shift(game.run.durability);
			(stat("onthrow"))(player, self, game.run.class == struct_default(game.WEAPON[abs(drop)], "class", game.DEFAULT_WEAPON), sign(drop) == -1);
			play_sfx(sfx_afuche);
			other.nopickup = self;
			other._nopickup = 0.2;
		}
	}
	if (atkInput && _reload <= 0) {
		play_sfx(sfx_hat);
		usenum++;
		var ch = instance_place(x, y, chest);
		if (ch != noone) {
			var _x = ch.x - (ch.x % 480);
			var _y = ch.y - (ch.y % 270);
			if (collision_rectangle(_x, _y, _x + 480, _y + 270, enemy, false, true) == noone) {
				particle_spawn(16, x, y);
				screen_shake(3, 0.5);
				var loot = 0;
				if (is_undefined(ch.loot)) loot = irandom(sprite_get_number(spr_weapon) - 5) + 4; // excluding FIST and 3 starter weapons
				else loot = ch.loot;
				play_sfx(sfx_chime);
				if (loot == 0) { // spawn WISH
					var z = instance_create_depth(0, 0, 0, wish);
					z.ch = ch;
				} else {
					with (instance_create_depth(x, y - 8, -1, drops)) {
						image_index = abs(loot);
						image_blend = sign(loot) == 1 ? c_white : c_yellow;
						yspeed = -400;
						player.nopickup = self;
						player._nopickup = 1;
					}
					instance_destroy(ch);
				}
			} else {}; // locked!
		}
		_reload = stat("reload") * game.run.reload;
		var _mindmg = stat("mindmg"); // TODO: add multiplier
		var _maxdmg = stat("maxdmg") * game.run.maxdmg;
		(stat("onuse"))(player, self, lerp(_mindmg, max(_mindmg, _maxdmg * stale), random(0.5) + 0.5), -_aim, game.run.class == stat("class"), sign(game.run.inventory[0]) == -1);
		_recoil = stat("recoil") * sign(random(2)-1);
		stale = max(0.1, stale * 0.9);
		if (game.run.durability[0] > 0) game.run.durability[0]--;
		if (game.run.durability[0] == 0) { // break!f
			(stat("onbreak"))(player, game.run.class == stat("class"), sign(game.run.inventory[0]) == -1);
			array_shift(game.run.inventory);
			array_shift(game.run.durability);
			usenum = 0;
			if (array_length(game.run.inventory) == 0) {
				array_push(game.run.inventory, 0);
				array_push(game.run.durability, -1);
			}
		}
	} else if (_reload > 0) _reload -= t;
	var drop = instance_nearest(xcenter, ycenter, drops);
	if (drop != noone && distance_to_object(drop) < 16 && (nopickup == noone || (drop.id != nopickup.id))) {
		var idx = pmod(drop.image_index, sprite_get_number(spr_weapon));
		if (game.run.inventory[0] == 0) {
			array_pop(game.run.inventory);
			array_pop(game.run.durability);
			usenum = 0;
			show_tooltip(struct_default(game.WEAPON[idx], "name", game.DEFAULT_WEAPON), 1, drop.image_blend);
			stale = 1;
		}
		array_push(game.run.inventory, idx * (drop.image_blend != c_white ? -1 : 1));
		array_push(game.run.durability, drop.durability);
		drop.onpickup();
		instance_destroy(drop);
		play_sfx(sfx_hat);
		play_sfx(sfx_hat2);
	}
	_aim = -darctan2(mouse_y - ycenter, mouse_x - xcenter);
	if (_immunity > 0) {
		_immunityBlink = !_immunityBlink;
		_immunity -= t;
	}
	if (game.run.inventory[0] < 0 && random(1) < 0.2) particle_spawn(1, x, y);
	if (_nopickup > 0) {
		_nopickup -= t;
		if (_nopickup <= 0) nopickup = noone;
	}
}

onground = function(yspeed) {
	_jump = 1;
}
onhurt = function(source, amount) {}
onhit = function(target, amount, weapon) {}