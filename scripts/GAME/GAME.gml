// feather ignore GM2022

function run_init() {
	game.run = json_parse(json_stringify(global.RUN_DEFAULT));
	game.run.name = game.save.name;
	game.gameSpeed = 1;
	game.save.deaths += 1;
	data_save();
}

function bullet_spawn(obj, lf, dmg, prio=0, spec=false, pier=false, etc) {
	var inst = instance_create_depth(xcenter, ycenter, -100, obj);
	with (inst) {
		friendly = other.object_index == player;
		parent = other;
		damage = dmg;
		cancel_priority = prio;
		spectral = spec;
		piercing = pier;
		if (lf > 0) _life = lf;
		if (!is_undefined(etc)) etc(other, self);
		if (other.object_index == player) weapon = game.run.inventory[0];
	}
	return inst;
}

function bullet_spawn_ext(obj, life, dmg, aim, speed, spread=0, size=1, prio=0, spec=false, pier=false, color=c_white, spr=spr_bullet) {
	global.arguments = { // grahh this engine sdjhgdfejkg
		aim: aim,
		color: color,
		size: size,
		spread: spread,
		speed: speed,
		spr: spr
	};
	return bullet_spawn(obj, life, dmg, prio, spec, pier, function(source, target) {
		target.sprite_index = global.arguments.spr;
		target.image_blend = global.arguments.color;
		target.image_xscale = global.arguments.size;
		target.image_yscale = global.arguments.size;
		var z = global.arguments.aim + vrandom(global.arguments.spread);
		target.image_angle = -z;
		target.xspeed = dcos(z) * global.arguments.speed;
		target.yspeed = dsin(z) * global.arguments.speed;
	});
}

function player_damage(source, amount, onhit) {
	if (player._immunity > 0) return;
	player._immunity = game.run.immunity;
	if (game.run.shield > 0) game.run.shield--;
	else {
		game.run.hp -= amount;
		array_remove(game.run.cosmetic_unlocks, 22);
	}
	if (!is_undefined(onhit)) onhit(source, instance_find(player, 0), amount);
	source.onhit(amount);
	(stat("onhurt"))(player, source, amount, game.run.class == stat("class"), game.run.inventory[0] < 0);
	if (instance_exists(player)) player.onhurt(source, amount);
	if (game.run.hp <= 0) player_die(source);
	play_sfx(sfx_cowbell);
	play_sfx(sfx_hat);
}

function enemy_damage(source, target, amount, onhit) {
	target.hp -= amount;
	if (!is_undefined(onhit)) onhit(source, target, amount);
	var weapon = is_undefined(source.weapon) ? 0 : source.weapon;
	(struct_default(game.WEAPON[abs(source.weapon)], "onhit", game.DEFAULT_WEAPON))(player, source, target, amount, game.run.class == struct_default(game.WEAPON[abs(source.weapon)], "class", game.DEFAULT_WEAPON), sign(source.weapon) == -1);
	if (instance_exists(player)) player.onhit(target, amount, weapon);
	global.temp = amount;
	particle_spawn(1, target.x, target.y, function(p) { 
		p.label = string_pretty(global.temp < 1 ? global.temp : floor(global.temp));
		p.angle = 0;
		p.aangle = vrandom(10);
		p.size = log10(global.temp + 1) + 1;
	});
	if (game.cameraX + 16 < target.x && target.x < game.cameraX + 464 && game.cameraY + 16 < target.y && target.y < game.cameraY + 254) array_remove(game.run.cosmetic_unlocks, 24);
	if (instance_exists(target)) target.onhurt(weapon, amount);
	if (target.hp <= 0) enemy_die(target);
}

function enemy_stun(target, r, a, duration) {
	global.temp = {r: r, a: a, duration: duration};
	target.changeState({
		duration: duration,
		onenter: function(this) {
			this.stunned = true;
			this.xspeed = global.temp.r * dcos(global.temp.a);
			this.yspeed = global.temp.r * dsin(global.temp.a);
		},
		onstep: function(this, t) {
			this.xspeed = lerp(this.xspeed, 0, 0.05);
		},
		onend: function(this) { this.stunned = false; return "idle"; }
	});
	target.stateName = "stunned";
}

function particle_spawn(amount, x, y, fn) {
	for (var i = 0; i < amount; i++) {
		var inst = instance_create_depth(x, y, -1, particle);
		if (!is_undefined(fn)) fn(inst);
	}
}

function screen_shake(amount, duration) {
	if (!is_undefined(amount)) game.screenshake = amount;
	if (!is_undefined(duration)) game.screenshakeDuration = duration;
	game._screenshakeDuration = game.screenshakeDuration;
}

function show_tooltip(text, duration, color=c_white) {
	if (!is_undefined(text)) game.tooltip = text;
	if (!is_undefined(duration)) game.tooltipDuration = duration;
	game.tooltipColor = color;
	game._tooltipDuration = game.tooltipDuration;
}

function show_title(text, duration, color=c_white) {
	with (instance_create_depth(0, 0, -100, center_text)) {
		if (!is_undefined(text)) label = text;
		if (!is_undefined(duration)) life = duration;
		image_blend = color;
		if (instance_exists(player)) { x = player.x; y = player.y; }
	}
}

function player_die(source) {
	var name = string(pmod(floor(source.image_index), sprite_get_number(source.sprite_index))) + "/" + source.enemyID;
	// add run info
	struct_nullish(game.save.died_to, name); game.save.died_to[$ name]++;
	var ret = save_run();
	ret.death = name;
	array_push(game.save.runs, ret);	
	instance_destroy(player);
	// display status screen
	with (instance_create_depth(game.cameraX, game.cameraY, -100, result_screen)) success = false;
	play_sfx(sfx_snare);
	play_sfx(sfx_chime);
}

function enemy_die(target) {
	var name = string(pmod(floor(target.image_index), sprite_get_number(target.sprite_index))) + "/" + target.enemyID;
	game.run.kills++; game.save.kills++;
	struct_nullish(game.run.killed, name); struct_nullish(game.save.killed, name);
	game.run.killed[$ name]++; game.save.killed[$ name]++;
	particle_spawn(8, target.x, target.y);
	screen_shake(2, 0.2);
	array_remove(game.run.cosmetic_unlocks, 13);
	target.ondeath();
	instance_destroy(target);
	play_sfx(sfx_hat);
	play_sfx(sfx_conga);
}

function rooms_get_opposite(dir) {
	var e = string_copy(dir, 2, string_length(dir) - 1);
	switch (string_char_at(dir, 1)) {
		case "r":
			e = "l" + e; break;
		case "l":
			e = "r" + e; break;
		case "u":
			e = "d" + e; break;
		case "d":
			e = "u" + e; break;
	}
	return e;
}

function rooms_get_offset(dir) {
	switch (string_char_at(dir, 1)) {
		case "r":
			return [1, 0];
		case "l":
			return [-1, 0];
		case "u":
			return [0, -1];
		case "d":
			return [0, 1];
	}
	return [0, 0];
}

function set_rooms(width, exits, size, special) {
	array_map(global.blocks, instance_destroy);
	global.blocks = [];
	game.rooms = [];
	var _x = 0; var _y = 0;
	for (var i = 0; i < array_length(exits); i++) {
		array_push(game.rooms, [_x * 480, _y * 270, _x * 480 + 480, _y * 270 + 270, string_split(exits[i], ",")]);
		_x++;
		if (_x == width) { _x = 0; _y++; }
	}
	var height = _y;
	_y += size + array_length(special);
	global.freeConnections = [];
	// entry
	game.dungeon = [{ idx: 0, pos: [_x, _y] }];
	global.temp = {_x: _x, _y: _y};
	array_map(game.rooms[game.dungeon[0].idx][4], function(a) { 
		var offset = rooms_get_offset(a)
		array_push(global.freeConnections, [global.temp._x + offset[0], global.temp._y + offset[1], a, 0]); 
	}); // add first connection
	// generate rooms
	for (var i = 0; i < size; i++) {
		if (array_length(global.freeConnections) == 0) return set_rooms(width, exits, size, special);
		var connection = array_random(global.freeConnections);
		var eligible = [];
		var op = rooms_get_opposite(connection[2]);
		for (var j = 0; j < array_length(game.rooms); j++) {
			if (j == 0 || array_contains(special, j) || j == connection[3]) continue;
			if (array_contains(game.rooms[j][4], op)) array_push(eligible, j);
		}
		if (array_length(eligible) == 0) { i--; continue; }
		connect_room(array_random(eligible), connection[0], connection[1]);
	}
	// generate specials
	for (var i = 0; i < array_length(special); i++) {
		global.found = false;
		global.temp = special[i];
		array_map(global.freeConnections, function(s) {
			if (global.found) return;
			var op = rooms_get_opposite(s[2]);
			if (array_contains(game.rooms[global.temp][4], op)) { // found!
				global.found = true;
				connect_room(global.temp, s[0], s[1]);
			}
		});
		if (!global.found) return set_rooms(width, exits, size, special);
	}
	// block off dead ends
	for (var i = 0; i < array_length(game.dungeon); i++) {
		for (var j = 0; j < array_length(game.rooms[game.dungeon[i].idx][4]); j++) {
			var d = game.rooms[game.dungeon[i].idx][4][j];
			var offset = rooms_get_offset(d);
			global.temp = {i: i, offset: offset};
			var r = array_find_index(game.dungeon, function(x) { 
				return x.pos[0] == game.dungeon[global.temp.i].pos[0] + global.temp.offset[0]
				&& x.pos[1] == game.dungeon[global.temp.i].pos[1] + global.temp.offset[1];
			});
			var op = rooms_get_opposite(d);
			if (r == -1 || !array_contains(game.rooms[game.dungeon[r].idx][4], op))
				block_room(game.dungeon[i].pos[0], game.dungeon[i].pos[1], d);
		}
	}
	// create solid block rooms
	var blanks = [];
	for (var i = 0; i < array_length(game.rooms); i++) if (game.rooms[i][4][0] == "") array_push(blanks, i);
	if (array_length(blanks) > 0) {
		var len = array_length(game.dungeon);
		for (var i = 0; i < len; i++) {
			var p = game.dungeon[i].pos;
			var ps = [[p[0] + 1, p[1] + 1], [p[0] + 1, p[1]], [p[0] + 1, p[1] - 1], [p[0], p[1] + 1], [p[0], p[1] - 1], [p[0] - 1, p[1] + 1], [p[0] - 1, p[1]], [p[0] - 1, p[1] - 1]];
			for (var k = 0; k < array_length(ps); k++) {
				var q = ps[k];
				var found = false;
				for (var j = 0; j < array_length(game.dungeon); j++) if (game.dungeon[j].pos[0] == q[0] && game.dungeon[j].pos[1] == q[1]) { found = true; break; }
				if (!found) array_push(game.dungeon, {idx: array_random(blanks), pos: [q[0], q[1]]});
			}
		}
	}
	// actually generate rooms
	for (var i = 0; i < array_length(game.dungeon); i++) {
		var r = game.rooms[game.dungeon[i].idx];
		var p = game.dungeon[i].pos;
		var from = [r[0], r[1], r[2], r[3]];
		var to = [p[0] * 480, p[0] * 480 + 480, p[1] * 270, p[1] * 270 + 270];
		global.temp = {r: r, p: p};
		ds_list_clear(game.temp);
		with (game) collision_rectangle_list(r[0] + 2, r[1] + 2, r[2] - 2, r[3] - 2, all, false, true, game.temp, false);
		map(game.temp, function(this) { with (this) with (instance_copy(true)) { if (object_index == chest && !is_undefined(other.loot)) loot = other.loot; if (object_index == zone) onenter = other.onenter; x = global.temp.p[0] * 480 - global.temp.r[0] + other.x; y = global.temp.p[1] * 270 - global.temp.r[1] + other.y; }});
	}
	// remove traces	
	ds_list_clear(game.temp);
	with (game) collision_rectangle_list(2, 2, width * 480 + 478, height * 270 + 268, all, false, true, game.temp, false);
	map(game.temp, function(this) { instance_destroy(this) });
	log(game.dungeon);
	// fetch boss
	game.bossString = "-1";
	if (game.save.online) with (game) global.boss = http_get("https://pub.colonq.computer/~prod/cgi-bin/api.cgi?action=chambers_load&room=" + room_get_name(room) + "&elo=" + string(save.elo));
}

function connect_room(idx, x, y) { 
	array_push(game.dungeon, { idx: idx, pos: [x, y] });
	global.temp = {x: x, y: y, idx: idx};
	array_map(game.rooms[idx][4], function(a) { 
		var offset = rooms_get_offset(a);
		global.temp.offset = offset;
		if (array_find_index(game.dungeon, function (x) {
			return x.pos[0] == global.temp.x + global.temp.offset[0]
			&& x.pos[1] == global.temp.y + global.temp.offset[1];
		}) == -1) {
			array_push(global.freeConnections, [global.temp.x + offset[0], global.temp.y + offset[1], a, global.temp.idx]); 
		}
	});
	global.temp = {x: x, y: y};
	global.freeConnections = array_filter(global.freeConnections, function (x) { return x[0] != global.temp.x || x[1] != global.temp.y; });
}

function block_room(x, y, c) {
	var _x = x * 480;
	var _y = y * 270;
	var _xs = 1;
	var _ys = 1;
	switch (string_char_at(c, 1)) {
		case "l":
			_ys = 270 / 16; break;
		case "r":
			_x += 464; _ys = 270 / 16; break;
		case "d":
			_y += 254; _xs = 480 / 16; break;
		case "u":
			_xs = 480 / 16; break;
	} 
	with (instance_create_depth(_x, _y, 1, block_new)) {
		image_xscale = _xs;
		image_yscale = _ys;
		image_blend = c_gray;
		array_push(global.blocks, self);
	}
}

function set_boss(res) {
	instance_activate_object(boss);
	if (!string_starts_with(res, "-1") && !string_starts_with(res, "***") && !string_starts_with(res, "<")) {
		var data = string_split(res, "\n")
		for (var i = 4; i < array_length(data); i++) data[i] = array_map(string_split(data[i], ","), real);
		game.bossID = real(data[0]);
		game.bossElo = real(data[1]);
		if (instance_exists(boss)) {
			boss.name = base64_decode_safe(data[2]);
			boss.date = date_from_timestamp(data[3]);
			boss.color_hair = data[4][0];
			boss.color_skin = data[4][1];
			boss.color_shirt = data[4][2];
			boss.color_arms = data[4][3];
			boss.color_legs = data[4][4];
			boss.color_legr = make_color_hsv(color_get_hue(boss.color_legs), color_get_saturation(boss.color_legs), color_get_value(boss.color_legs) * 0.5);
			boss.type_hair = data[4][5];
			boss.type_cosmetic = data[4][6];
			boss.inventory = array_shuffle(data[5]);
			boss.jump = data[6][0];
			boss.move = data[6][1];
			boss.mindmg = data[6][2];
			boss.maxdmg = data[6][3];
			boss.reload = data[6][4];
			boss.class = data[6][5];
			boss.hp = data[6][6] * 50;
			boss.maxhp = boss.hp;
			boss.multishot = data[6][7];
			boss.accuracy = data[7][0];
			boss.aggressiveness = data[7][1];
			boss.moviness = data[7][2];
			boss.jumpiness = data[7][3];
			boss.switchiness = data[7][4];
		}
		game.bossString = "-1";
	}
}

function play_bgm(idx) {
	audio_stop_sound(game.bgm);
	game.bgm = audio_play_sound(idx, 0, true, game.save.bgm);
}

function play_sfx(idx) {
	audio_play_sound(idx, 0, false, game.save.sfx);
}

function setup_compendium(spr, page) {
	// setup of setup
	global.COMPENDIUM_COL = 5;
	global.COMPENDIUM_ROW = 2;
	instance_destroy(arrow);
	instance_destroy(compendium_button);
	instance_destroy(compendium_text);
	global.temp = {spr: spr, page: page};
	var get = function(i, key) { return struct_default(global.temp.spr == spr_cosmetic ? game.COSMETICS[i] : game.WEAPON[i], key, game.DEFAULT_WEAPON); }
	var has = function(i) { return array_contains(global.temp.spr == spr_cosmetic ? game.save.cosmetic_unlocks : game.save.weapon_unlocks, i); }
	// spawn arrows
	var head = page * global.COMPENDIUM_COL * global.COMPENDIUM_ROW;
	var tail = head + (global.COMPENDIUM_COL * global.COMPENDIUM_ROW);
	if (page > 0) with (instance_create_depth(30, 135, 0, arrow)) { onchange = function(t) { setup_compendium(global.temp.spr, global.temp.page - 1); }; image_xscale = -4; image_yscale = 4; };
	if (tail < sprite_get_number(spr)) with (instance_create_depth(450, 135, 0, arrow)) { onchange = function(t) { setup_compendium(global.temp.spr, global.temp.page + 1); }; image_xscale = 4; image_yscale = 4; };
	// generate buttons
	global.temp.text = instance_create_depth(240, 240, 0, compendium_text);
	for (var j = 0; j < global.COMPENDIUM_ROW; j++) {
		for (var i = 0; i < global.COMPENDIUM_COL; i++) {
			if (head >= sprite_get_number(spr)) break; 
			var _x = lerp(32, 448, (i + 0.5) / global.COMPENDIUM_COL);
			var _y = lerp(64, 230, (j + 0.5) / global.COMPENDIUM_ROW);
			with (instance_create_depth(_x, _y, 0, compendium_button)) {
				image_xscale = 2;
				image_yscale = image_xscale;
				label = has(head) ? get(head, "name") + "\n" + get(head, "desc") : get(head, "unlock");
				image_blend = has(head) ? c_white : make_color_rgb(128, 0, 0);
				if (spr == spr_cosmetic) { 
					if (get(head, "unlock") != "") unlock = c_lime; 
				}
				else {
					switch (get(head, "class")) {
						case 1:
							unlock = c_red;
							break;
						case 2:
							unlock = c_lime;
							break;
						case 3:
							unlock = c_aqua;
							break;
					}
					if (has(head)) label += "Used in " + string(game.save.won_with[$ head]) + " runs";
					else label += "Win the game holding this item to unlock this entry."
				}
				self.spr = spr;
				idx = head;
			}
			head++;
		}
	}
}

function save_run() {
	var ret = json_parse(json_stringify(game.run));
	struct_remove(ret, "durability");
	struct_remove(ret, "hp");
	struct_remove(ret, "shield");
	struct_remove(ret, "cosmetic_unlocks");
	ret.date = date_timestamp();
	if (game.save.online) ret.elo = game.save.elo;
	return ret;
}

function describe_run(run) {
	var get_sprite = function(s) { return object_get_sprite(asset_get_index(string_split(s, "/")[1])); }
	var get_name = function(s) { return string_upper(string_char_at(s, 1)) + string_lower(string_copy(s, 2, string_length(s) - 1)); }
	var get_index = function(s) { return real(string_split(s, "/")[0]); }
	var success = !struct_exists(run, "death");
	// sets
	draw_set_color(c_black);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text_outline(x + 48, y + 64, success ? "Conquested:" : "Vanquished by:", c_white);
	var PORT_X = x + 76;
	var PORT_Y = y + 128;
	var PORT_SIZE = 2;
	if (success) {
		draw_sprite_ext(spr_player, 1, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, run.color_skin, 1);
		draw_sprite_ext(spr_player, 2, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, run.color_shirt, 1);
		draw_sprite_ext(spr_player, 3, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, run.color_arms, 1);
		draw_sprite_ext(spr_player, 4, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, run.color_legs, 1);
		draw_sprite_ext(spr_player, 5, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, make_color_hsv(color_get_hue(run.color_legs), color_get_saturation(run.color_legs), color_get_value(run.color_legs) * 0.5), 1);
		draw_sprite_ext(spr_hair, run.type_hair, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, run.color_hair, 1);
		draw_sprite_ext(spr_cosmetic, run.type_cosmetic, PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, c_white, 1);
		var it = array_random(run.opponent_inventory);
		draw_sprite_ext(spr_weapon, abs(it), PORT_X + (6 * PORT_SIZE), PORT_Y - (9 * PORT_SIZE), PORT_SIZE, PORT_SIZE, 0, sign(it) == 1 ? c_white : c_yellow, 1);
		draw_text_outline(x + 92, y + 112, get_name(run.opponent_name), c_white);
	} else {
		draw_sprite_ext(get_sprite(run.death), get_index(run.death), PORT_X, PORT_Y, PORT_SIZE, PORT_SIZE, 0, c_white, 1);
		draw_text_outline(x + 92, y + 112, get_name(string_split(run.death, "/")[1]), c_white);
	}
	draw_text_outline(x + 48, y + 144, "Loot Gathered", c_white);
	var items = [0, 0, (run.immunity - 1) * 2, 0, (run.jump - 500) / 25, (run.move - 350) / 25, run.mystery, run.multishot * 20, (run.maxdmg - 1) * 4, run.mindmg * 4];
	var category = 0; var idx = 0; var ks = struct_get_names(run.weapon_used);
	for (; idx < array_length(ks); idx += 2) {
		if (idx % 16 == 0 && idx % 32 != 0) idx += 16;
		var _x = x + 48 + (6 * (idx % 16));
		var _y = y + 172 + (6 * floor(idx / 16));
		draw_sprite(spr_weapon, abs(ks[idx]), _x, _y);
	}
	while (category < array_length(items)) {
		if (items[category] <= 0) category++;
		else {
			var _x = x + 48 + (6 * (idx % 16));
			var _y = y + 172 + (6 * floor(idx / 16));
			draw_sprite(spr_item, category, _x, _y);
			idx++;
			items[category]--;
		}
	}
	draw_set_halign(fa_right);
	var classes = ["Entity", "Warrior", "Hunter", "Mage"];
	draw_text_outline(x + 432, y + 36, run.name + " the " + classes[run.class], c_white);
	var t = get_timer() / 1000000;
	struct_nullish(run, "isPB"); struct_nullish(run, "unlocks", "");
	draw_text_outline(x + 432, y + 64, "Time: " + format_time(run.igt), run.isPB ? make_color_hsv(t * 255, 255, 255) : c_white);	
	draw_set_font(global.fnt_small);
	draw_text_outline(x + 432, y + 80, "RTA: " + format_time(run.rta), c_gray);	
	draw_set_font(fnt_alagard);
	draw_text_outline(x + 432, y + 96, "Foes Defeated:", c_white);
	var bk = array_length(run.bosses_killed) == 0 ? ["None"] : run.bosses_killed;
	draw_text_outline(x + 432, y + 112, string_join_ext("\n", bk), c_white);
	draw_text_outline(x + 432, y + 128 + (14 * array_length(bk)), "Items Unlocked:", c_white);
	draw_text_outline(x + 432, y + 144 + (14 * array_length(bk)), run.unlocks == "" ? "None" : run.unlocks, run.unlocks == "" ? c_white : c_lime);
}

function setup_stats() {
	instance_destroy(arrow);
	instance_destroy(stats_text);
	instance_destroy(log_text);
	instance_create_depth(0, 32, 0, stats_text);
}

function setup_logs(i) {
	global.temp = {i:i};
	instance_destroy(arrow);
	instance_destroy(stats_text);
	instance_destroy(log_text);
	if (i > 0) with (instance_create_depth(30, 135, 0, arrow)) { onchange = function(t) { setup_logs(global.temp.i - 1); }; image_xscale = -4; image_yscale = 4; };
	if (i < array_length(game.save.runs) - 1) with (instance_create_depth(450, 135, 0, arrow)) { onchange = function(t) { setup_logs(global.temp.i + 1); }; image_xscale = 4; image_yscale = 4; };
	with (instance_create_depth(0, 32, 0, log_text)) { run = game.save.runs[i]; }
}

function show_tutorial(label, text) {
	if (array_contains(game.save.seentutorial, label)) return;
	array_push(game.save.seentutorial, label);
	with (instance_create_depth(game.cameraX, game.cameraY, -199, tutorial)) {
		self.title = label;
		self.text = text;
		if (instance_exists(player)) { x = player.x - pmod(player.x, 480); y = player.y - pmod(player.y, 270); }
	}
	// proon
	if (array_length(game.save.seentutorial) == 7) {
		if (instance_exists(player)) array_push(game.run.cosmetic_unlocks, 5);
		else array_push(game.save.cosmetic_unlocks, 5);
	}
}