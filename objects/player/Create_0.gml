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
enemyID = "player";

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
jumping = false;

deathclicks = 0;

// movement
onstep = function(t) {
	// move
	var ai = instance_exists(boss) && boss.activate;
	var hInput = input_check(game.save.right, game.save.left);
	var vInput = input_check(game.save.jump);
	var atkInput = input_check(game.save.attack) || input_check(game.save.attack2);
	var switchInput = input_check_pressed(game.save.reload) || input_check_pressed(game.save.reload2);
	var deathInput = input_check_pressed(game.save.death);
	if (game.gameSpeed > 0 && input_check_pressed(game.save.cancel) && !instance_exists(pause)) {
		instance_create_depth(game.cameraX, game.cameraY, -200, pause);
	}
	if (input_check(game.save.peek) && !game.save.peekwithaim) { hInput = 0; vInput = 0; }
	xspeed = lerp(xspeed, hInput * game.run.move, 0.5);
	if (vInput && _jump) { yspeed = -game.run.jump; _jump -= 1; jumping = true; }
	if (jumping && !vInput) jumping = false;
	if (yspeed < 0 && !jumping) yspeed += 2 * grav * t;
	if (hInput != 0) face = hInput;
	// aim
	var xInput = input_check(game.save.aimright, game.save.aimleft);
	var yInput = input_check(game.save.aimdown, game.save.aimup);
	if (xInput == 0 && yInput == 0) // mouse aiming!	
		_aim = -darctan2(mouse_y - ycenter, mouse_x - xcenter);
	else _aim = -darctan2(yInput, xInput); // keyboard aiming!
	if (input_check(game.save.aimreverse)) _aim += 180; // aim reverse!
	// attack
	if (atkInput && _reload <= 0) {
		// calculate after effects
		usenum++;
		if (game.run.inventory[0] != 0) show_tutorial("Stale and Durability", "Bar on the left indicates your stale meter. The stale meter falls every time you use the same weapon, and the lower your stale meter the lower your damage will be. Some weapons have greater damage falloff than others. The number at the bottom is this weapon's durability, and can be repaired with an item.");
		var k = abs(game.run.inventory[0]);
		if (!struct_exists(game.run.weapon_used, k)) {
			struct_nullish(game.run.weapon_used, k);
			game.run.weapon_used[$ k]++;
		}
		stale = max(0.1, stale * 0.9);
		_reload = stat("reload") * game.run.reload;
		_recoil = stat("recoil") * sign(random(2)-1);
		deathclicks = 0;
		// damage
		var _mindmg = stat("mindmg"); // TODO: add multiplier
		var _maxdmg = stat("maxdmg") * game.run.maxdmg;
		var _dmg = lerp(_mindmg, max(_mindmg, _maxdmg * stale), random(0.5) + 0.5);
		(stat("onuse"))(player, self, _dmg, -_aim, game.run.class == stat("class"), sign(game.run.inventory[0]) == -1);
		var m = game.run.multishot;
		while (m > 1) {m--; (stat("onuse"))(player, self, _dmg, -_aim + vrandom(15), game.run.class == stat("class"), sign(game.run.inventory[0]) == -1); }
		if (random(1) < m) { (stat("onuse"))(player, self, _dmg, -_aim + vrandom(15), game.run.class == stat("class"), sign(game.run.inventory[0]) == -1) };
		if (ai) accuracy_d += _dmg;
		// calculate durability
		if (game.run.durability[0] > 0) game.run.durability[0]--;
		if (game.run.durability[0] == 0) { // break: separate from above for durability 0 (super one use) items
			(stat("onbreak"))(player, game.run.class == stat("class"), sign(game.run.inventory[0]) == -1);
			array_shift(game.run.inventory);
			array_shift(game.run.durability);
			usenum = 0;
			stale = 1;
			if (array_length(game.run.inventory) == 0) {
				array_push(game.run.inventory, 0);
				array_push(game.run.durability, -1);
			}
		}
		// other left click actions
		play_sfx(sfx_hat);
	} else if (_reload > 0) _reload -= t;
	// switch
	if (switchInput) {
		stale = 1;
		if (game.run.inventory[0] != 0) show_tutorial("Throwing", "You must throw the weapon you're holding to switch to the next weapon. the queue is shown at the bottom left corner. To switch quickly, throw your weapons to the ground by aiming below your feet.");
		var drop = array_shift(game.run.inventory);
		if (array_length(game.run.inventory) == 0) {
			array_push(game.run.inventory, 0);
			if (drop == 0) return;
			array_push(game.run.durability, 0);
		}
		var p = stat("class") == game.run.class ? "+" : "";
		show_tooltip(stat("name") + p, 1, game.run.inventory[0] < 0 ? c_yellow : c_white);
		with (instance_create_depth(xcenter, ycenter, -1, drops)) {
			image_index = abs(drop);
			image_blend = sign(drop) == 1 ? c_white : c_yellow;
			xspeed = game.run.jump * dcos(-other._aim);
			yspeed = game.run.jump * dsin(-other._aim);
			_durability = array_shift(game.run.durability);
			(struct_default(game.WEAPON[abs(drop)], "onthrow", game.DEFAULT_WEAPON))(player, self, game.run.class == struct_default(game.WEAPON[abs(drop)], "class", game.DEFAULT_WEAPON), sign(drop) == -1);
			play_sfx(sfx_afuche);
			other.nopickup = self;
			other._nopickup = 0.2;
		}
	}
	// pickups
	var drop = instance_nearest(xcenter, ycenter, item);
	if (drop != noone && distance_to_object(drop) < 16 && (nopickup == noone || (drop.id != nopickup.id))) {
		with (drop) event_perform(ev_other, ev_user0);
		instance_destroy(drop);
		play_sfx(sfx_hat);
		play_sfx(sfx_hat2);
	};
	
	var drop = instance_nearest(xcenter, ycenter, drops);
	if (drop != noone && distance_to_object(drop) < 16 && (nopickup == noone || (drop.id != nopickup.id))) {
		var idx = pmod(drop.image_index, sprite_get_number(spr_weapon));
		if (game.run.inventory[0] == 0) {
			array_pop(game.run.inventory);
			array_pop(game.run.durability);
			usenum = 0;
			var p = struct_default(game.WEAPON[idx], "class", game.DEFAULT_WEAPON) == game.run.class ? "+" : "";
			show_tooltip(struct_default(game.WEAPON[idx], "name", game.DEFAULT_WEAPON) + p, 1, drop.image_blend);
			stale = 1;
		}
		array_push(game.run.inventory, idx * (drop.image_blend != c_white ? -1 : 1));
		array_push(game.run.durability, drop.durability);
		drop.onpickup();
		instance_destroy(drop);
		play_sfx(sfx_hat);
		play_sfx(sfx_hat2);
	}
	// other calculation
	if (game.run.inventory[0] < 0 && random(1) < 0.2) particle_spawn(1, x, y);
	if (_nopickup > 0) {
		_nopickup -= t;
		if (_nopickup <= 0) nopickup = noone;
	}
	if (_immunity > 0) {
		_immunityBlink = !_immunityBlink;
		_immunity -= t;
	}
	if (deathInput) {
		deathclicks++;
		play_sfx(sfx_kick)
		if (deathclicks >= 5) player_die(player);
	}
	if (ai) {
		moviness_d++;
		jumpiness_d++;
		switchiness_d += t;
		aggressiveness_d++;
		if (hInput != 0) moviness++;
		if (vInput) jumpiness++;
		if (switchInput) switchiness++;
		aggressiveness += sqr((480 - distance_to_object(boss)) / 480);
	}
}
image_speed = 0;
onground = function(yspeed) { _jump = 1; global.wr = false; }
onhurt = function(source, amount) {}
onhit = function(target, amount, weapon) {}

// frags: also send inventory
accuracy_d = 0;
aggressiveness_d = 0;
moviness_d = 0;
jumpiness_d = 0;
switchiness_d = 0;
accuracy = 0;
aggressiveness = 0;
moviness = 0;
jumpiness = 0;
switchiness = 0;