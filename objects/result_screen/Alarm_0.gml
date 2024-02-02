// calculate elo
if (!game.save.online) {
	// handle save for non-online things
	data_save();
	return;
}
if (!instance_exists(boss) || boss.activate) {
	game.save.elo = elo_calculate(game.save.elo, game.bossElo, success);
	game.bossElo = elo_calculate(game.bossElo, game.save.elo, !success);
	var args = ["opponent=" + string(game.bossID), "opponent_elo=" + string(game.bossElo)];
	if (success) { // send frag data to the web zone!
		array_push(args, "action=chambers_win"); 
		var inventory = [];
		for (var i = 0; i < array_length(game.run.inventory); i++) array_push(inventory, game.run.inventory[i]);
		ds_list_clear(game.temp);
		for (var i = 0; i < collision_rectangle_list(game.cameraX, game.cameraY, game.cameraX + 480, game.cameraY + 480, drops, false, true, game.temp, false); i++) {
			var inst = game.temp[| i];
			var idx = pmod(inst.image_index, sprite_get_number(spr_weapon));
			if (inst.image_blend != c_white) idx *= -1;
			array_push(inventory, idx);
		}
		var data = {
			room: room_get_name(room),
			name: base64_encode_safe(game.save.name),
			date: date_timestamp(),
		    elo: game.save.elo,
			cosmetic: string_join_ext(",", [game.save.color_hair, game.save.color_skin, game.save.color_shirt, game.save.color_arms, game.save.color_legs, game.save.type_hair, game.save.type_cosmetic]),
			stats: string_join_ext(",", [game.run.jump, game.run.move, game.run.mindmg, game.run.maxdmg, game.run.reload, game.run.class, global.temp_hp, game.run.multishot]),
			inventory: string_join_ext(",", inventory),
			ai: string_join_ext(",", array_map([(player.accuracy_d == 0) ? 0 : player.accuracy/player.accuracy_d, (player.aggressiveness_d == 0) ? 0 : player.aggressiveness/player.aggressiveness_d, (player.moviness_d == 0) ? 0 : player.moviness/player.moviness_d, (player.jumpiness_d == 0) ? 0 : player.jumpiness/player.jumpiness_d, (player.switchiness_d == 0) ? 0 : player.switchiness/player.switchiness_d], function(x) { return string_format(x, 1, 12); }))
		};
		var ks = struct_get_names(data);
		for (var i = 0; i < array_length(ks); i++) {
			var k = ks[i];
			var v = data[$ ks[i]];
			array_push(args, string(k) + "=" + string(v));
		}
	} else array_push(args, "action=chambers_loss"); // count losses
	with (game) global.save = http_get("https://pub.colonq.computer/~prod/cgi-bin/api.cgi?" + string_join_ext("&", args));
}
// button
if (!success) {
	with (instance_create_depth(x + 400, y + 224, depth - 1, generic_button)) {
		text = "Return";
		onclick = function() { room_goto(rm_title); play_bgm(bgm_main); }
	}
} else if (room == rm_stage3) {
	with (instance_create_depth(x + 400, y + 224, depth - 1, generic_button)) {
		text = "Proceed";
		onclick = function() { room_goto(rm_credits); play_bgm(bgm_main); }
	}
} else {
	with (instance_create_depth(x + 400, y + 224, depth - 1, generic_button)) {
		text = "Proceed";
		onclick = function() { room_goto(rm_lobby); play_bgm(bgm_main); array_push(game.run.cleared, room); }
	}
}
data_save();