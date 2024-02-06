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
			name: "No Cosmetic",
			unlock: "",
			desc: "Clean and Classic"
		},
		{
			name: "Verified",
			unlock: "Defeat (or become) LCOLONQ.",
			desc: "Defeat (or become) LCOLONQ."
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
			name: ":proon:",
			unlock: "Read all tutorials.",
			desc: "Read all tutorials."
		},
		{
			name: "Gamer",
			unlock: "Win the game.",
			desc: "Win the game."
		},
		{
			name: "Ox Reaction",
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
			name: "Extra Lives",
			unlock: "?? Become So Back ??",
			desc: "Win with less than 1 HP."
		},
		{
			name: "Cute Bow",
			unlock: "?? Get Extremely Buffed ??",
			desc: "Reach >15 Health."
		},
		{
			name: "Super Bnuuyhop",
			unlock: "?? AGILE is Key ??",
			desc: "Beat the game within X minutes."
		},
		{
			name: "\"Friend\"",
			unlock: "?? Let The Creatures Live ??",
			desc: "Win without killing any non-boss enemies."
		},
		{
			name: "The Law",
			unlock: "?? Get a Speeding Ticket ??",
			desc: "Win without entering the first area."
		},
		{
			name: "Tinfoil Hat",
			unlock: "?? Wish for Annihilation ??",
			desc: "Obtain a Nuke."
		},
		{
			name: "Nature Spirit",
			unlock: "?? Hunt Barehanded ??",
			desc: "Beat the first boss only using your fists."
		},
		{
			name: "Mark of Enemy",
			unlock: "?? Become a Challenger ??",
			desc: "Gain Over 2000 ELO."
		},
		{
			name: "Featherly Pride",
			unlock: "?? Wrap Around Endlessly ??",
			desc: "Beat the final boss without touching the ground."
		},
		{
			name: "Glitch Gremlin",
			unlock: "?? Explore the Far Lands ??",
			desc: "Go out of bounds."
		},
		{
			name: "Game Ender",
			unlock: "?? Dominate Your Opponent ??",
			desc: "Beat the final boss in 5 seconds or less."
		},
		{
			name: "Chat is this real",
			unlock: "?? Be Mysterious ??",
			desc: "Gain 10 or more \"Mystery\" points."
		},
		{
			name: "Wizard's Hat",
			unlock: "?? Become Insanely Cracked ??",
			desc: "Beat the game without taking damage."
		},
		{
			name: "Developers",
			unlock: "?? \"Developers\" ??",
			desc: "Wish for \"Developers\"."
		},
		{
			name: "Chamber Master",
			unlock: "?? Out of Sight, Out of Mind ??",
			desc: "Win without killing anyone on screen."
		}
	];
	
	DEFAULT_WEAPON = {
		name: "",
		unlock: "",
		desc: "",
		reload: 0.2,
		mindmg: 1,
		maxdmg: 1,
		recoil: 0,
		class: 0,
		durability: 10,
		spawnsin: [rm_stage1, rm_stage2, rm_stage3],
		onuse: function(user, this, dmg, aim, isPlus, isGold) {/*noop*/},
		onhit: function(user, this, target, dmg, isPlus, isGold) {},
		onhurt: function(user, source, dmg, isPlus, isGold) {},
		onthrow: function(user, drop, isPlus, isGold) {},
		onbreak: function(user, isPlus, isGold) {},
		stale: 0.9,
	};
	
	WEAPON = [
		{
			spawnsin: [],
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				 with (this) with (bullet_spawn_ext(bullet, 0.1, dmg, aim, 0, 0, 1, 2, false, true, c_white, spr_fist)) {}; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 150, -darctan2(target.y - this.y, target.x - this.x), 0.05); },
		},
		{
			name: "Iron Sword",
			spawnsin: [rm_stage2],
			reload: 0.5,
			mindmg: 3.5,
			maxdmg: 10,
			recoil: 60,
			class: 1,
			durability: 100,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, isPlus ? 0.6 : 0.2, dmg, aim, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.4); },
		},
		{
			name: "Cacophony",
			spawnsin: [rm_stage2],
			reload: 0.5,
			mindmg: 4,
			maxdmg: 6,
			recoil: 5,
			class: 2,
			durability: 100,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				global.temp_4i957 = isPlus;
				with (this) with (bullet_spawn_ext(bullet, -1, dmg, aim, 300, 2, 1, 0, false, false, c_white, spr_arrow2)) onstep = function(t) { yspeed += t * (global.temp_4i957 ? 100 : 300); }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 60, -darctan2(target.y - this.y, target.x - this.x), 0.2); },
		},
		{
			name: "Ol' Reliable",
			spawnsin: [rm_stage2],
			reload: 0.7,
			mindmg: 1,
			maxdmg: 3,
			recoil: 25,
			class: 3,
			durability: 9999,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					var z = bullet_spawn_ext(bullet, -1, dmg, aim, 200, 0, 1, 2, true, false, c_white, spr_windstrike);
					with (z) onstep = function(t) { damage = max(0.1, damage - t); }; 
					if (!isPlus) z.damage /= 10;
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 60, -darctan2(target.y - this.y, target.x - this.x), 0.2); },
		},
		{
			name: "Warspear",
			spawnsin: [rm_stage1, rm_stage2],
			reload: 0.75,
			mindmg: 20,
			maxdmg: 30,
			recoil: 5,
			class: 1,
			durability: 10,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) bullet_spawn_ext(bullet_fading, 1.5, dmg, aim, 60, 3, 1.25, 3, true, true, c_white, spr_spike); 
				if (isPlus && instance_exists(user)) { user._immunity = 1; user.xspeed = 700 * dcos(aim); user.yspeed = 700 * dsin(aim); }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 800, -darctan2(target.y - this.y, target.x - this.x), 1.5); },
		},
		{
			name: "Gun",
			spawnsin: [rm_stage1, rm_stage2],
			reload: 0.1,
			mindmg: 4,
			maxdmg: 4,
			recoil: 40,
			class: 2,
			durability: 40,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) bullet_spawn_ext(bullet, -1, dmg, aim, 450, 10, 1, 0, false, false, c_gray); 
				if (!isPlus) user._reload = 0.5 * game.run.reload;
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 100, -darctan2(target.y - this.y, target.x - this.x), 0.4); },
		},
		{
			name: "Dark Grimoire",
			spawnsin: [rm_stage2, rm_stage3],
			reload: 0.7,
			mindmg: 10,
			maxdmg: 50,
			recoil: 15,
			class: 3,
			durability: 10,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, isPlus ? 5 : 1, dmg, aim, isPlus ? 240 : 360, 0, 1, 1, true, true, c_white, spr_skull)) onstep = function(t) { damage = max(0.1, damage - t); }; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 1); },
		},
		{
			name: "Gray47beard's Swashbuckler",
			spawnsin: [rm_stage1, rm_stage2],
			reload: 1.2,
			mindmg: 1,
			maxdmg: 20,
			recoil: 60,
			class: 1,
			durability: 10,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				this.isPlus = isPlus;
				with (this) {
					var size = isPlus ? 1.25 : 0.75;
					with (this) bullet_spawn_ext(bullet_fading, 1.5, dmg, aim + 30, 150, 0, isPlus, 2, false, true, c_white, spr_spike); 
					global.bucker_temp = {dmg: dmg, aim: aim};
					with (this) timeout(0.1, function() { bullet_spawn_ext(bullet_fading, 1.5, global.bucker_temp.dmg, global.bucker_temp.aim, 150, 0, isPlus, 3, true, true, c_white, spr_spike); });
					with (this) timeout(0.2, function() { bullet_spawn_ext(bullet_fading, 1.5, global.bucker_temp.dmg, global.bucker_temp.aim - 30, 150, 0, isPlus, 3, true, true, c_white, spr_spike); });
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.5); },
		},
		{
			name: "Rune Knives",
			spawnsin: [rm_stage1, rm_stage2],
			reload: 0.4,
			mindmg: 0,
			maxdmg: 73,
			recoil: 30,
			class: 2,
			durability: 15,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, isPlus ? 2 : 0.4, dmg, aim, 240, 0, 0.75, 1, true, true, c_white, spr_spike)) onstep = function(t) { yspeed += t * 200; };  
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 100, -darctan2(target.y - this.y, target.x - this.x), 0.4); },
			onthrow: function(user, drop, isPlus, isGold) { global.knife_temp = drop; global.knife_user = user; timeout(0.5, function() {
				if (instance_exists(global.knife_user) && instance_exists(global.knife_temp)) {
					var aim = darctan2(global.knife_temp.y - global.knife_user.ycenter, global.knife_temp.x - global.knife_user.xcenter);
					global.knife_user._immunity = 1; global.knife_user.xspeed = 700 * dcos(aim); global.knife_user.yspeed = 700 * dsin(aim);
				}
			}); },
		},
		{
			name: "Magic Tricks",
			spawnsin: [rm_stage1],
			reload: 4,
			mindmg: 100,
			maxdmg: 300,
			recoil: 15,
			class: 3,
			durability: 1,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, isPlus ? 120 : 5, dmg, aim, 0, 0, 1, 1, true, true, c_white, spr_smoke)) onstep = function(t) { damage = max(0.1, damage - t); }; 
				if (instance_exists(user)) { user.yspeed = -500; }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 5); },
		},
		{
			name: "Death's Scythe",
			spawnsin: [rm_stage2, rm_stage3],
			reload: 1.2,
			mindmg: 4,
			maxdmg: 44,
			recoil: 60,
			class: 1,
			durability: 25,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim, 100, 0, 2, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
					if (isPlus) {
						with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim + 150, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
						with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim + 180, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
						with (bullet_spawn_ext(bullet_fading, 0.4, dmg, aim + 210, 100, 0, 1, 2, true, true, c_white, spr_slash)) onstep = function(t) { image_xscale += 0.25 * t; image_yscale += 0.25 * t }; 
					}
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.5); },
		},
		{
			name: "Suspicious Lizard",
			spawnsin: [rm_stage2, rm_stage3],
			reload: 0,
			mindmg: 0,
			maxdmg: 2,
			recoil: 10,
			class: 2,
			durability: 1000,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet, 1, dmg, aim, 800, 30, 0.5, 0)) {};  
				if (instance_exists(user)) { user.xspeed = -240 * dcos(aim); user.yspeed = -240 * dsin(aim); }
				if (!isPlus) user._reload = max(user._reload, 0.1);
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 60, -darctan2(target.y - this.y, target.x - this.x), 0.05); },
		},
		{
			name: "Web Dev",
			spawnsin: [rm_stage2, rm_stage3],
			reload: 4,
			mindmg: 2,
			maxdmg: 5,
			recoil: 5,
			class: 3,
			durability: 5,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 3, dmg, aim, 240, 0, 1, 1, false, true, c_white, spr_js)) {}; 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), isPlus ? 1200 : 10); },
		},
		{
			name: "Stardust",
			spawnsin: [rm_stage1, rm_stage2],
			class: 2,
			reload: 1,
			mindmg: 5,
			maxdmg: 11,
			recoil: 45,
			durability: 15,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					with (bullet_spawn_ext(bullet_fading, 4, dmg, aim, 240, 0, 1, 1, false, true, c_white, spr_stardust)) {image_blend = make_color_hsv(random(255), 255 * 0.5, 255);}; 
					if (isPlus) {
						with (bullet_spawn_ext(bullet_fading, 4, dmg, aim + 40, 240, 0, 1, 1, false, true, c_white, spr_stardust)) {image_blend = make_color_hsv(random(255), 255 * 0.5, 255);}; 
						with (bullet_spawn_ext(bullet_fading, 4, dmg, aim + 20, 240, 0, 1, 1, false, true, c_white, spr_stardust)) {image_blend = make_color_hsv(random(255), 255 * 0.5, 255);}; 
						with (bullet_spawn_ext(bullet_fading, 4, dmg, aim - 20, 240, 0, 1, 1, false, true, c_white, spr_stardust)) {image_blend = make_color_hsv(random(255), 255 * 0.5, 255);}; 
						with (bullet_spawn_ext(bullet_fading, 4, dmg, aim - 40, 240, 0, 1, 1, false, true, c_white, spr_stardust)) {image_blend = make_color_hsv(random(255), 255 * 0.5, 255);}; 
					}
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 240, -darctan2(target.y - this.y, target.x - this.x), 0.5); },
		},
		{
			name: "Placeholder",
			spawnsin: [rm_stage2, rm_stage3],
			class: 2,
			reload: 0.25,
			mindmg: 2,
			maxdmg: 9,
			recoil: 5,
			durability: 77,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) bullet_spawn_ext(bullet_fading, 30, dmg, aim, 600, 0, 1, 0, isPlus, true, c_white, spr_placeholder) 
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 300, -darctan2(target.y - this.y, target.x - this.x), 0.5); },
		},
		{
			name: "Harrison",
			spawnsin: [rm_stage2, rm_stage3],
			class: 2,
			reload: 5,
			mindmg: 10,
			maxdmg: 25,
			recoil: 1800,
			durability: 2,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					var z = bullet_spawn_ext(bullet_fading, 30, dmg, aim, 600, 0, 1, isPlus ? 1 : 0, false, false, c_white) 
					z.isPlus = isPlus;
					z.onstep = function(t) { yspeed += t * 200; }
					z.dmg = dmg;
					z.ondestroy = function(t) {
						with (t) {
							var inst = instance_create_depth(x, y, -100, bullet_fading);
							inst.friendly = friendly;
							inst.parent = parent;
							inst.damage = isPlus ? dmg * 10 : dmg;
							inst.cancel_priority = isPlus ? 3 : 0;
							inst.spectral = true;
							inst.piercing = true;
							inst._life = 5;
							inst.weapon = weapon;
							inst.sprite_index = spr_smoke;
						}
					}
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 600, -darctan2(target.y - this.y, target.x - this.x), 1); },
		},
		{
			name: "Wife Material",
			spawnsin: [rm_stage1, rm_stage2],
			class: 1,
			reload: 0.7,
			mindmg: 16,
			maxdmg: 20,
			recoil: 3,
			durability: 50,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 0.6, dmg, 0, 0, 0, isPlus ? 2 : 1, 1, true, true, c_white, spr_slash2)) { onstep = function(t) { image_xscale += t; image_yscale += t; } }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 200, -darctan2(target.y - this.y, target.x - this.x), 0.7); },
		},
		{
			name: "Python 4",
			spawnsin: [rm_stage3],
			class: 1,
			reload: 0.1,
			mindmg: 2,
			maxdmg: 8,
			recoil: 15,
			durability: 200,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) with (bullet_spawn_ext(bullet_fading, 0.2, dmg, 0, 0, 15, isPlus ? 16 : 8, 0, true, true, c_white, spr_slash2)) { image_yscale = 1; }
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 0.7); },
		},
		{
			name: "Oversized Determined Sword of Ultimate Demonic Darkness",
			spawnsin: [rm_stage3],
			class: 1,
			reload: 999,
			mindmg: 99999,
			maxdmg: 99999,
			recoil: 60,
			durability: 1,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) bullet_spawn_ext(bullet_fading, 15, dmg, aim, 0, 0, 4, 0, true, true, c_white, spr_slash);
				if (isPlus) user._reload = 60;
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 0, -darctan2(target.y - this.y, target.x - this.x), 30); },
		},
		{
			name: "Mine Flayer",
			spawnsin: [rm_stage2, rm_stage3],
			class: 3,
			reload: 1,
			mindmg: 0.5,
			maxdmg: 5,
			recoil: 15,
			durability: 50,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				with (this) {
					var z = bullet_spawn_ext(bullet_fading, 1, dmg, aim, 0, 0, 0.5, 0, false, false, c_gray, spr_stardust) 
					z.isPlus = isPlus;
					z.dmg = dmg;
					z.ondestroy = function(t) {
						with (t) {
							var inst = instance_create_depth(x, y, -100, bullet_fading);
							inst.friendly = friendly;
							inst.parent = parent;
							inst.damage = isPlus ? dmg * 10 : dmg;
							inst.cancel_priority = isPlus ? 1 : 0;
							inst.spectral = true;
							inst.piercing = true;
							inst._life = 2;
							inst.image_xscale = 0.5;
							inst.image_yscale = 0.5;
							inst.weapon = weapon;
							inst.sprite_index = spr_smoke;
						}
					}
				}
			},
			onhit: function(user, this, target, dmg, isPlus, isGold) { enemy_stun(target, 400, -darctan2(target.y - this.y, target.x - this.x), 1); },
		},
		{
			name: "Taco Bell",
			spawnsin: [rm_stage2, rm_stage3],
			class: 3,
			reload: 5,
			mindmg: 20,
			maxdmg: 20,
			recoil: 60,
			durability: 50,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				user._immunity = 1.2;
				if (isPlus && this.object_index == player) object_foreach(enemy, function(x) { enemy_stun(x, 400, 180-darctan2(x.y - player.y, x.x - player.x), 1); })
				with (this) with (bullet_spawn_ext(bullet, 2, dmg, 0, 0, 0, 1.5, isPlus ? 0 : 3, true, true, c_yellow, spr_smoke)) { image_alpha = 0.1; }
			},
		},
		{
			name: "Nuke",
			spawnsin: [],
			class: 3,
			reload: 0,
			mindmg: 99999,
			maxdmg: 99999,
			recoil: 60,
			durability: 1/3,
			onuse: function(user, this, dmg, aim, isPlus, isGold) { 
				instance_activate_object(enemy);
				instance_deactivate_object(boss);
				with (this) bullet_spawn_ext(bullet_fading, 0, 99999, 0, 0, 0, 100, 100, true, true, c_white, spr_smoke);
			},
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
	file_text_close(f);
	var new_save = json_parse(str);
	var keys = struct_get_names(new_save);
	for (var i = 0; i < array_length(keys); i++) {
		game.save[$ keys[i]] = new_save[$ keys[i]]; // Object.assign this
	}
	if (!struct_exists(new_save, "seentutorial")) { // old version save
		game.save.cosmetic_unlocks = game.DEFAULT_SAVE.cosmetic_unlocks;
		game.save.runs = [];
	}
}

function stat(key) { return struct_default(game.WEAPON[abs(game.run.inventory[0])], key, game.DEFAULT_WEAPON); } 

function string_pretty(n) {
	if (n == -1) return "Inf";
	if (n == 0) return "???";
	if (floor(n) != n) return string_trim_end(string(n), ["0"]);
	return string(n);
}

