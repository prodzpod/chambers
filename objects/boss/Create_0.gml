event_inherited();
_names = ["John Rogue", "Little Timmy", "prodzpod", "notLCOLONQ", "sorry :("];
name = array_random(_names);
inventory = [];
for (var i = 0; i < 5; i++) array_push(inventory, -irandom(array_length(game.WEAPON) - 2) + 1);
hp = 250;

color_hair = make_color_rgb(random(255), random(255), random(255));
color_skin = make_color_rgb(random(255), random(255), random(255));
color_shirt = make_color_rgb(random(255), random(255), random(255));
color_arms = make_color_rgb(random(255), random(255), random(255));
color_legs = make_color_rgb(random(255), random(255), random(255));
color_legr = make_color_hsv(color_get_hue(color_legs), color_get_saturation(color_legs), color_get_value(color_legs) * 0.5);
type_hair = irandom(sprite_get_number(spr_hair) - 1);
type_cosmetic = irandom(sprite_get_number(spr_cosmetic) - 1);

face = -1;
distb = 0;
distp = 0;
aimb = 0;

activate = false;

states = {
	idle: {
		duration: 0.5,
		onend: function() { return boss.activate ? "active" : "idle"; }
	},
	active: {
		onstep: function(this, t) { with (this) {
			if (distp < 32) {
				if (dcos(_aim) != 0) face = (_reload < 0.3 ? -1 : 1) * sign(dcos(_aim));
				if (_jump > 0) { yspeed = -500; _jump -= 1; }
			}
			else if (distb != -1 && distb < 64) {
				if (dcos(aimb) != 0) face = (_reload < 0.3 ? -1 : 1) * sign(dcos(aimb));
				if (_jump > 0) { yspeed = -500; _jump -= 1; }
			}
			else if (random(1) < 0.02) face = -face;
			xspeed = 200 * face;
			
			_reload -= t;
			if (_reload <= 0) {
				_reload = enemystat("reload") * 1.5;
				var _mindmg = enemystat("mindmg"); // TODO: add multiplier
				var _maxdmg = enemystat("maxdmg");
				(enemystat("onuse"))(boss, self, (log10(lerp(_mindmg, _maxdmg, random(0.5)) + 1) + 1) * 0.5, -_aim, false, true);
				_recoil = enemystat("recoil") * sign(random(2)-1);
				if (random(1) < 0.1) inventory = array_shuffle(inventory);
			}
		}},
		onend: function() { return "active"; }
	}
}
state = states.idle;

enemystat = function(key) { return struct_default(game.WEAPON[abs(inventory[0])], key, game.DEFAULT_WEAPON); }

onground = function(yspeed) {
	_jump = 1;
}

headbuttDamage = 0;

// stats
_jump = 1;
_reload = 7;
_recoil = 0;