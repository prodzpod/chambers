if (ds_map_find_value(async_load, "id") == global.boss)
{
    if ds_map_find_value(async_load, "status") == 0
	{
		// set boss stats
        var res = ds_map_find_value(async_load, "result");
		// show_tooltip(res, 5);
		if (!string_starts_with(res, "-1") && !string_starts_with(res, "***") && !string_starts_with(res, "<")) {
			var data = string_split(res, "\n")
			for (var i = 4; i < array_length(data); i++) data[i] = array_map(string_split(data[i], ","), real);
			bossID = real(data[0]);
			bossElo = real(data[1]);
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
		}
    }
}