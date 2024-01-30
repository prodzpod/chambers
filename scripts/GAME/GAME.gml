// feather ignore GM2022

function run_init() {
	game.run = global.RUN_DEFAULT;
	game.gameSpeed = 1;
	game.save.deaths += 1;
	array_push(game.save.runs, {death: "Disconnection", inventory: []});
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
		if (lf > 0) life = lf;
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
	game.run.hp -= amount;
	if (!is_undefined(onhit)) onhit(source, instance_find(player, 0), amount);
	source.onhit(amount);
	(stat("onhurt"))(player, source, amount, game.run.class == stat("class"), game.run.inventory[0] < 0);
	player.onhurt(source, amount);
	if (game.run.hp <= 0) player_die(source);
	play_sfx(sfx_cowbell);
	play_sfx(sfx_hat);
}

function enemy_damage(source, target, amount, onhit) {
	target.hp -= amount;
	if (!is_undefined(onhit)) onhit(source, target, amount);
	var weapon = is_undefined(source.weapon) ? 0 : source.weapon;
	(struct_default(game.WEAPON[abs(source.weapon)], "onhit", game.DEFAULT_WEAPON))(player, source, target, amount, game.run.class == struct_default(game.WEAPON[abs(source.weapon)], "class", game.DEFAULT_WEAPON), sign(source.weapon) == -1);
	player.onhit(target, amount, weapon);
	global.temp = amount;
	particle_spawn(1, target.x, target.y, function(p) { 
		p.label = string(floor(global.temp * 100) / 100);
		p.angle = 0;
		p.aangle = vrandom(10);
		p.size = log10(global.temp + 1) + 1;
	});
	if (instance_exists(source.parent)) source.parent.onhurt(weapon, amount);
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
			this.xspeed = lerp(this.xspeed, 0, 0.9);
			this.yspeed = lerp(this.yspeed, 0, 0.9);
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

function player_die(source) {
	array_pop(game.save.runs);
	// add run info
	var name = object_get_name(source.object_index);
	if (!struct_exists(game.save.died_to, name)) game.save.died_to[$ name] = 0;
	game.save.died_to[$ name]++;
	instance_destroy(player);
	// display status screen
	game.alarm[2] = 180;
	play_sfx(sfx_snare);
	play_sfx(sfx_chime);
}

function enemy_die(target) {
	var name = object_get_name(target.object_index);
	game.save.kills++;
	if (!struct_exists(game.save.killed, name)) game.save.killed[$ name] = 0;
	game.save.killed[$ name]++;
	particle_spawn(8, target.x, target.y);
	screen_shake(2, 0.2);
	if (target.object_index == boss) game.alarm[3] = 180;
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
	_y += 10;
	global.freeConnections = [];
	// entry
	game.dungeon = [{ idx: 0, pos: [_x, _y] }];
	global.temp = {_x: _x, _y: _y};
	array_map(game.rooms[game.dungeon[0].idx][4], function(a) { 
		var offset = rooms_get_offset(a)
		array_push(global.freeConnections, [global.temp._x + offset[0], global.temp._y + offset[1], a]); 
	}); // add first connection
	// generate rooms
	for (var i = 0; i < size; i++) {
		if (array_length(global.freeConnections) == 0) return set_rooms(width, exits, size, special);
		var connection = array_random(global.freeConnections);
		var eligible = [];
		var op = rooms_get_opposite(connection[2]);
		for (var j = 0; j < array_length(game.rooms); j++) {
			if (j == 0 || array_contains(special, j)) continue;
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
	// actually generate rooms
	for (var i = 0; i < array_length(game.dungeon); i++) {
		var r = game.rooms[game.dungeon[i].idx];
		var p = game.dungeon[i].pos;
		var from = [r[0], r[1], r[2], r[3]];
		var to = [p[0] * 480, p[0] * 480 + 480, p[1] * 270, p[1] * 270 + 270];
		global.temp = {r: r, p: p};
		ds_list_clear(game.temp);
		collision_rectangle_list(r[0] + 2, r[1] + 2, r[2] - 2, r[3] - 2, block, false, false, game.temp, false);
		collision_rectangle_list(r[0] + 2, r[1] + 2, r[2] - 2, r[3] - 2, semisolid, false, false, game.temp, false);
		collision_rectangle_list(r[0] + 2, r[1] + 2, r[2] - 2, r[3] - 2, physics, false, false, game.temp, false);
		map(game.temp, function(this) { with (this) with (instance_copy(true)) { if (object_index == chest && !is_undefined(other.loot)) loot = other.loot; x = global.temp.p[0] * 480 - global.temp.r[0] + other.x; y = global.temp.p[1] * 270 - global.temp.r[1] + other.y; }});
	}
	// remove traces	
	ds_list_clear(game.temp);
	collision_rectangle_list(2, 2, width * 480 + 478, height * 270 + 268, block, false, false, game.temp, false);
	collision_rectangle_list(2, 2, width * 480 + 478, height * 270 + 268, semisolid, false, false, game.temp, false);
	collision_rectangle_list(2, 2, width * 480 + 478, height * 270 + 268, physics, false, false, game.temp, false);
	map(game.temp, function(this) { instance_destroy(this) });
	log(game.dungeon);
	// fetch boss
	with (game) {
		global.boss = http_get("http://pub.colonq.computer/~prod/cgi-bin/api.cgi?room=" + room_get_name(room) + "&elo=" + string(game.save.elo));
	}
}

function connect_room(idx, x, y) { 
	array_push(game.dungeon, { idx: idx, pos: [x, y] });
	global.temp = {x: x, y: y};
	array_map(game.rooms[idx][4], function(a) { 
		var offset = rooms_get_offset(a);
		global.temp.offset = offset;
		if (array_find_index(game.dungeon, function (x) {
			return x.pos[0] == global.temp.x + global.temp.offset[0]
			&& x.pos[1] == global.temp.y + global.temp.offset[1];
		}) == -1) {
			log("pushing", a, "from", global.temp.x, global.temp.y);
			array_push(global.freeConnections, [global.temp.x + offset[0], global.temp.y + offset[1], a]); 
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

function play_bgm(idx) {
	audio_stop_sound(game.bgm);
	game.bgm = audio_play_sound(idx, 0, true, game.save.bgm);
}

function play_sfx(idx) {
	audio_play_sound(idx, 0, false, game.save.sfx);
}