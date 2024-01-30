function init_data() {
	CLASSES = [
		{
			name: "Undecided",
			desc: "Affinity to Nothing",
		},
		{
			name: "Warrior",
			desc: "Affinity to Melee",
		},
		{
			name: "Hunter",
			desc: "Affinity to Ranged",
		},
		{
			name: "Mage",
			desc: "Affinity to Magic",
		}
	];

	COSMETICS = [
		{
			name: "",
			unlock: "",
			desc: ""
		},
		{
			name: "Verified",
			unlock: "",
			desc: "Become Verified"
		},
		{
			name: "Yellow Page",
			unlock: "",
			desc: "Never Ever!"
		},
		{
			name: "Cat Ears",
			unlock: "",
			desc: "mrrp!"
		},
		{
			name: "Cool Shxdes",
			unlock: "",
			desc: "All good."
		},
		{
			name: ":3",
			unlock: "",
			desc: ">:3c"
		},
		{
			name: "Gamer",
			unlock: "Beat 1 game.",
			desc: "Beat 1 game."
		},
		{
			name: "Ghoul Mode",
			unlock: "Die once.",
			desc: "Die once."
		},
		{
			name: ":ox:",
			unlock: "Beat the game as Warrior.",
			desc: "Beat the game as Warrior."
		},
		{
			name: "Not Ears",
			unlock: "Beat the game as Hunter.",
			desc: "Beat the game as Hunter."
		},
		{
			name: "EVAL APPLY",
			unlock: "Beat the game as Mage.",
			desc: "Beat the game as Mage."
		},
		{
			name: "Cute Bow",
			unlock: "Reach Maximum Health.",
			desc: "Reach Maximum Health."
		},
		{
			name: "Bnuuy",
			unlock: "Beat the game within X minutes.",
			desc: "Beat the game within X minutes."
		},
		{
			name: "\"Friend\"",
			unlock: "...Friendly...Peaceful...",
			desc: "Win without killing any boss minions."
		},
		{
			name: "The Law",
			unlock: "...Disordered...Rebelling...",
			desc: "Win without entering the first area."
		},
		{
			name: "Tinfoil Hat",
			unlock: "...Atomic...Secret...",
			desc: "Obtain a Golden Nuke."
		},
		{
			name: "Nature Spirit",
			unlock: "...Wooden...Mundane...",
			desc: "Win without using Guns as Hunter."
		},
		{
			name: "Im Geezer",
			unlock: "...Jong...Tenpai...",
			desc: "Unlocks in April Fools."
		},
		{
			name: "Symbol of Flight",
			unlock: "...Lava...Hovering...",
			desc: "Beat the final boss without touching the ground."
		},
		{
			name: "Glitch Gremlin",
			unlock: "...Boundless...Exceptions...",
			desc: "Go out of bounds."
		},
		{
			name: "The Game Ender",
			unlock: "...Obliteration...Domination...",
			desc: "Beat the final boss in 5 seconds or less."
		},
		{
			name: "Is this a Bit",
			unlock: "...Peculiar...Indirect...",
			desc: "Beat the final boss without hitting it."
		},
		{
			name: "Wizard Hat",
			unlock: "...Bearded...Magical...",
			desc: "Beat the game without taking damage."
		},
		{
			name: "Developers",
			unlock: "...Developers...Developers...",
			desc: "Wish for \"Developers\"."
		},
		{
			name: "Bright Idea",
			unlock: "...Creative...Sneaky...",
			desc: "Win without killing normal monsters on screen."
		}
	];
	
	DEFAULT_WEAPON = {
		name: "",
		desc: "",
		reload: 0.2,
		mindmg: 1,
		maxdmg: 1,
		recoil: 0,
		class: 0,
		durability: 10,
		onuse: function(user, this, dmg, aim, isPlus, isGold) {/*noop*/},
		onhit: function(user, this, target, dmg, isPlus, isGold) {},
		onhurt: function(user, source, dmg, isPlus, isGold) {},
		onthrow: function(user, drop, isPlus, isGold) {},
		onbreak: function(user, isPlus, isGold) {},
		stale: 0.9,
	};
	
	WEAPON = [
		{
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				 with (this) with (bullet_spawn_ext(bullet, 0.1, dmg, aim, 0, 0, 1, 2, false, true, c_white, spr_fist)) {}; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 150, -darctan2(target.y - this.y, target.x - this.x), 0.15); },
		},
		{
			name: "Iron Sword",
			reload: 0.5,
			mindmg: 3.5,
			maxdmg: 10,
			recoil: 60,
			class: 1,
			durability: 100,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.4); },
		},
		{
			name: "The Cacophony",
			reload: 0.5,
			mindmg: 4,
			maxdmg: 6,
			recoil: 5,
			class: 2,
			durability: 100,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet, -1, dmg, aim, 300, 10, 1, 2, false, false, c_white, spr_arrow2)) onstep = function(t) { yspeed += t * 200; }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 60, -darctan2(target.y - this.y, target.x - this.x), 0.2); },
		},
		{
			name: "Ol' Reliable",
			reload: 0.7,
			mindmg: 1,
			maxdmg: 3,
			recoil: 25,
			class: 3,
			durability: 9999,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet, -1, dmg, aim, 200, 0, 1, 2, true, false, c_white, spr_windstrike)) onstep = function(t) { damage = max(0.1, damage - t); }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 60, -darctan2(target.y - this.y, target.x - this.x), 0.2); },
		},
		{
			name: "Warspear",
			reload: 0.75,
			mindmg: 20,
			maxdmg: 30,
			recoil: 5,
			class: 1,
			durability: 10,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 1.5, dmg, aim, 60, 3, 1.25, 3, true, true, c_white, spr_spike)) {}; 
				if (instance_exists(user)) { user.xspeed = 500 * dcos(aim); user.yspeed = 500 * dsin(aim); }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 30, -darctan2(target.y - this.y, target.x - this.x), 1.5); },
		},
		{
			name: "Gun",
			reload: 0.1,
			mindmg: 4,
			maxdmg: 4,
			recoil: 40,
			class: 2,
			durability: 40,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet, -1, dmg, aim, 450, 10, 1, 0, true, false, c_gray)) {}; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 100, -darctan2(target.y - this.y, target.x - this.x), 0.4); },
		},
		{
			name: "Dark Grimoire",
			reload: 0.7,
			mindmg: 25,
			maxdmg: 50,
			recoil: 15,
			class: 3,
			durability: 10,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 3, dmg, aim, 240, 0, 1, 1, true, true, c_white, spr_skull)) onstep = function(t) { damage = max(0.1, damage - t); }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 1); },
		},
		{
			name: "Gray47beard's Swashbuckler",
			reload: 1.2,
			mindmg: 1,
			maxdmg: 20,
			recoil: 60,
			class: 1,
			durability: 10,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					bullet_spawn_ext(bullet_fading, 1.5, dmg, aim + 15, 150, 0, 1.25, 2, false, true, c_white, spr_spike); 
					global.bucker_temp = {dmg: dmg, aim: aim};
					timeout(0.25, function() { bullet_spawn_ext(bullet_fading, 1.5, global.bucker_temp.dmg, global.bucker_temp.aim, 150, 0, 1, 3, true, true, c_white, spr_spike); });
					timeout(0.5, function() { bullet_spawn_ext(bullet_fading, 1.5, global.bucker_temp.dmg, global.bucker_temp.aim - 15, 150, 0, 1, 3, true, true, c_white, spr_spike); });
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.5); },
		},
		{
			name: "Rune Knives",
			reload: 0.4,
			mindmg: 0,
			maxdmg: 20,
			recoil: 30,
			class: 2,
			durability: 15,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 1, dmg, aim, 240, 0, 0.75, 0, false, true, c_white, spr_spike)) onstep = function(t) { yspeed += t * 200; };  
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 100, -darctan2(target.y - this.y, target.x - this.x), 0.4); },
			onthrow: function(user, drop, isPlus, isGold) { global.knife_temp = drop; global.knife_user = user; timeout(0.5, function() {
				if (instance_exists(global.knife_user) && instance_exists(global.knife_temp)) {
					var aim = darctan2(global.knife_temp.y - global.knife_user.ycenter, global.knife_temp.x - global.knife_user.xcenter);
					global.knife_user.xspeed = 500 * dcos(aim); global.knife_user.yspeed = 500 * dsin(aim);
				}
			}); },
		},
		{
			name: "Magic Tricks",
			reload: 4,
			mindmg: 200,
			maxdmg: 200,
			recoil: 15,
			class: 3,
			durability: 3,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 120, dmg, aim, 0, 0, 1, 1, true, true, c_white, spr_smoke)) onstep = function(t) { damage = max(0.1, damage - t); }; 
				if (instance_exists(user)) { user.yspeed = -500; }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 5); },
		},
		{
			name: "Death's Scythe",
			reload: 1.2,
			mindmg: 4,
			maxdmg: 14,
			recoil: 60,
			class: 1,
			durability: 25,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
					with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim + 120, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
					with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim + 180, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
					with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim + 240, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.5); },
		},
		{
			name: "Suspicious Lizard",
			reload: 0,
			mindmg: 0.5,
			maxdmg: 1,
			recoil: 10,
			class: 2,
			durability: 900,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet, 1, dmg, aim, 800, 30, 0.5, 0)) {};  
				if (instance_exists(user)) { user.xspeed = -240 * dcos(aim); user.yspeed = -240 * dsin(aim); }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 60, -darctan2(target.y - this.y, target.x - this.x), 0.05); },
		},
		{
			name: "Web Dev",
			reload: 4,
			mindmg: 2,
			maxdmg: 5,
			recoil: 5,
			class: 3,
			durability: 5,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 3, dmg, aim, 240, 0, 1, 1, true, true, c_white, spr_js)) {}; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 1200); },
		}
	];
}

function data_save() {
	if os_browser != browser_not_a_browser return;
	var f = file_text_open_write("./save.json");
	file_text_write_string(f, json_stringify(game.save, true));
	file_text_close(f);
	show_tooltip("Game Saved", 1);
}

function data_load() {
	if os_browser != browser_not_a_browser return;
	var f = file_text_open_read("./save.json");
	var str = "";
	while (!file_text_eof(f)) str += file_text_readln(f);
	var new_save = json_parse(str);
	var keys = struct_get_names(new_save);
	for (var i = 0; i < array_length(keys); i++) {
		game.save[$ keys[i]] = new_save[$ keys[i]]; // Object.assign this
	}
	file_text_close(f);
}

function stat(key) { return struct_default(game.WEAPON[abs(game.run.inventory[0])], key, game.DEFAULT_WEAPON); } 