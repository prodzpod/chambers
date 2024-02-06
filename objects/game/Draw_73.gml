var cam = view_get_camera(view_current);
var offsetX = 480 * __cameraOffX;
var offsetY = 270 * __cameraOffY;
if (_screenshakeDuration > 0) {
	var intensity = save.shake * screenshake * _screenshakeDuration / screenshakeDuration
	offsetX += vrandom(intensity);
	offsetY += vrandom(intensity);
}
camera_set_view_pos(cam, cameraX + offsetX, cameraY + offsetY);
if (room != rm_character && instance_exists(player)) {
	for (var i = 0; i < array_length(game.run.inventory); i++)
		draw_sprite_ext(spr_weapon, abs(game.run.inventory[i]), cameraX + offsetX + 8 + (16 * i), cameraY + offsetY + 262, 1, 1, 90, sign(game.run.inventory[i]) == 1 ? c_white : c_yellow, 1);
	for (var i = 0; i < game.run.hp; i++)
		draw_sprite_ext(spr_heart, 0, cameraX + offsetX + 8 + (8 * i), cameraY + offsetY + 8, 1, 1, 0, c_white, 1);
	if (game.run.hp % 1 != 0) {
		var i = 4 - floor((game.run.hp % 1) * 5);
		draw_sprite_ext(spr_heart, i, cameraX + offsetX + 8 + (8 * floor(game.run.hp)), cameraY + offsetY + 8, 1, 1, 0, c_white, 1);
	}
	for (var i = 0; i < game.run.shield; i++) {
		if (i > ceil(game.run.hp)) draw_sprite_ext(spr_heart, i, cameraX + offsetX + 8 + (8 * i), cameraY + offsetY + 8, 1, 1, 0, c_black, 1);
		draw_sprite_ext(spr_heart, 0, cameraX + offsetX + 8 + (8 * i), cameraY + offsetY + 8, 1, 1, 0, c_aqua, 0.5);
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var z = floor(max(game.run.hp, game.run.shield));
	draw_text_outline(cameraX + offsetX + 8 + (8 * z), cameraY + offsetY + 8, string_pretty(game.run.hp), c_white);
	if (game.run.shield > 0) {
	var wz = string_width(string_pretty(game.run.hp));
		draw_text_outline(cameraX + offsetX + 10 + wz + (8 * z), cameraY + offsetY + 8, "+" + string_pretty(game.run.shield), make_color_rgb(128, 255, 255));
	}
	var stc = make_color_hsv(0, 0, player.stale * 255);
	draw_set_color(c_black);
	draw_rectangle(cameraX + offsetX + 8, cameraY + offsetY + 24, cameraX + offsetX + 20, cameraY + offsetY + 216, false);
	draw_set_color(stc);
	draw_rectangle(cameraX + offsetX + 10, cameraY + offsetY + 214 - (188 * player.stale), cameraX + offsetX + 18, cameraY + offsetY + 214, false);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_text_outline(cameraX + offsetX + 4, cameraY + offsetY + 119, string_pretty(floor(player.stale * 100)) + "%", stc);
	draw_text_outline(cameraX + offsetX + 8, cameraY + offsetY + 220, string_pretty(game.run.durability[0]), c_white);
}

if (_tooltipDuration > 0) {
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_text_color(cameraX + offsetX + 8, cameraY + offsetY + 242, tooltip, tooltipColor, tooltipColor, tooltipColor, tooltipColor, 1 - sqr(1 - (_tooltipDuration / tooltipDuration)));
}

if (instance_exists(boss) && boss.activate) {
	var stc = make_color_hsv(0, 255, (boss.hp / boss.maxhp) * 128 + 127);
	draw_set_color(c_black);
	draw_rectangle(cameraX + offsetX + 460, cameraY + offsetY + 24, cameraX + offsetX + 472, cameraY + offsetY + 216, false);
	draw_set_color(stc);
	draw_rectangle(cameraX + offsetX + 462, cameraY + offsetY + 214 - (188 * (boss.hp / boss.maxhp)), cameraX + offsetX + 470, cameraY + offsetY + 214, false);
	draw_set_halign(fa_right);
	draw_set_valign(fa_middle);
	draw_text_outline(cameraX + offsetX + 476, cameraY + offsetY + 119, boss.name, stc);
	draw_text_outline(cameraX + offsetX + 476, cameraY + offsetY + 220, string_pretty(boss.hp), stc);
}

if (os_browser != browser_not_a_browser && room == rm_init) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(c_white);
	draw_text(240, 135, "Click to Start");
	draw_set_color(c_gray);
	draw_set_font(global.fnt_small);
	draw_text_ext(240, 200, "Web version: saves and bloom will not work in this version!", 7, 240);
	draw_set_font(fnt_alagard);
}