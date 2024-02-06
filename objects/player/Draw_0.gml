var alpha = image_alpha;
if (_immunity > 0 && _immunityBlink) alpha = lerp(alpha, 0, _immunity / game.run.immunity);

// @description draw little guy

draw_sprite_ext(spr_player, 1, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_skin), alpha);
draw_sprite_ext(spr_player, 2, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_shirt), alpha);
draw_sprite_ext(spr_player, 3, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_arms), alpha);
draw_sprite_ext(spr_player, 4, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_legs), alpha);
draw_sprite_ext(spr_player, 5, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_legr), alpha);

draw_sprite_ext(spr_hair, type_hair, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_hair), alpha);
draw_sprite_ext(spr_cosmetic, type_cosmetic, x, y, image_xscale * face, image_yscale, image_angle, image_blend, alpha);
var aim = _aim;
if (_reload > 0) aim += _recoil * _reload / game.run.reload / stat("reload");
if (face == -1) aim += 180;
draw_sprite_ext(spr_weapon, abs(game.run.inventory[0]), x + (6 * face), ycenter, image_xscale * face, image_yscale, image_angle + aim, sign(game.run.inventory[0]) == 1 ? c_white : c_yellow, alpha);
if (room != rm_character) {
	draw_sprite_ext(spr_aim, -1, xcenter, ycenter, image_xscale * face, image_yscale, image_angle + _aim + 90 - (90 * face), image_blend, image_alpha);
	if (_reload > 0) {
		draw_set_font(global.fnt_small);
		draw_text_outline(x + 4, y - 20, string_pretty(ceil(_reload * 10) / 10), c_white);
		draw_set_font(fnt_alagard);
	}
}