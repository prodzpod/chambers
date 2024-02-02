event_inherited();
// stats
game.bossID = -1;
game.bossElo = 1000;
_names = ["John Rogue", "Rogue Andy", "Little Timmy", "prodzpod", "NPC", "Hal 8080", "notLCOLONQ", "Wifi Error", "who?", "Mysterious Figure", "Shadow Man", "Entity"];
name = array_random(_names);
date = date_current_datetime();
color_hair = make_color_rgb(random(255), random(255), random(255));
color_skin = make_color_rgb(random(255), random(255), random(255));
color_shirt = make_color_rgb(random(255), random(255), random(255));
color_arms = make_color_rgb(random(255), random(255), random(255));
color_legs = make_color_rgb(random(255), random(255), random(255));
color_legr = make_color_hsv(color_get_hue(color_legs), color_get_saturation(color_legs), color_get_value(color_legs) * 0.5);
type_hair = irandom(sprite_get_number(spr_hair) - 1);
type_cosmetic = irandom(sprite_get_number(spr_cosmetic) - 1);
inventory = [];
for (var i = 0; i < 5; i++) array_push(inventory, -irandom(array_length(game.WEAPON) - 2) + 1);
jump = 500;
move = 350;
mindmg = 0; 
maxdmg = 1;	
reload = 0.75; 
class = irandom(2) + 1;
hp = 250;
multishot = 0;
accuracy = 0.2 + random(0.6);
aggressiveness = 0.2 + random(0.6);
moviness = 0.2 + random(0.6);
jumpiness = 0.2 + random(0.6);
switchiness = 0.2 + random(0.6);

face = -1;
distb = 0;
distp = 0;
aimb = 0;

stop = 0;

activate = false;

states = {
	idle: {
		duration: 0.5,
		onend: function() { return boss.activate ? "active" : "idle"; }
	},
	active: {
		duration: 999,
		onstep: function(this, t) { with (this) {
			if (distp < 32 && dcos(_aim) != 0) face = (_reload < enemystat("reload") * reload * aggressiveness ? -1 : 1) * sign(dcos(_aim));
			else if (distb != -1 && distb < 64 && dcos(aimb) != 0) face = (_reload < aggressiveness ? -1 : 1) * sign(dcos(aimb));
			if (_jump > 0 && random(1) < jumpiness) { yspeed = -jump; _jump -= 1; }
			else if (random(1) < 0.02) face = -face;
			xspeed = lerp(xspeed, stop <= 0 ? move * face : 0, 0.5);
			if (stop > 0) stop -= t;
			else if (random(1) < 0.02) {
				stop = lerp(t * 50, 0, moviness);
				stop = stop / 2 + random(stop);
			}
			_reload -= t;
			if (_reload <= 0) {
				_reload = enemystat("reload") * reload;
				var _mindmg = enemystat("mindmg"); // TODO: add multiplier
				var _maxdmg = enemystat("maxdmg");
				var __aim = _aim;
				if (random(1) < (1 - accuracy)) __aim += sign(vrandom(1)) * random(sqr(1 / max(0.02, accuracy)));
				var m = multishot;
				(enemystat("onuse"))(boss, self, (log10(lerp(_mindmg, _maxdmg, random(0.5)) + 1) + 1) * 0.5, __aim, enemystat("class") == class, inventory[0] < 0);
				while (m > 1) {m--; (enemystat("onuse"))(boss, self, (log10(lerp(_mindmg, _maxdmg, random(0.5)) + 1) + 1) * 0.5, __aim + vrandom(15), enemystat("class") == class, inventory[0] < 0); }
				if (random(1) < m) { (enemystat("onuse"))(boss, self, (log10(lerp(_mindmg, _maxdmg, random(0.5)) + 1) + 1) * 0.5, __aim + vrandom(15), enemystat("class") == class, inventory[0] < 0) };
				_recoil = enemystat("recoil") * sign(random(2) - 1);
				if (random(1) < switchiness) inventory = array_shuffle(inventory);
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

onhurt = function(weapon, amount) { if (instance_exists(player)) player.accuracy += amount; }

headbuttDamage = 0;

// stats
_jump = 1;
_reload = random(1);
_recoil = 0;