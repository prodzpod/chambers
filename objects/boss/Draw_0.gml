function color_multiply(c1, c2) {
	return make_color_rgb(color_get_red(c1) * color_get_red(c2) / 255, color_get_green(c1) * color_get_green(c2) / 255, color_get_blue(c1) * color_get_blue(c2) / 255);
}
var alpha = image_alpha;
if (stateName == "stunned" && _headbuttImmuneBlink) alpha = lerp(alpha, 0, 0.7);
else if (_headbuttImmune > 0 && _headbuttImmuneBlink) alpha = lerp(alpha, 0, _headbuttImmune / headbuttImmune);
draw_sprite_ext(spr_player, 1, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_skin), alpha);
draw_sprite_ext(spr_player, 2, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_shirt), alpha);
draw_sprite_ext(spr_player, 3, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_arms), alpha);
draw_sprite_ext(spr_player, 4, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_legs), alpha);
draw_sprite_ext(spr_player, 5, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_legr), alpha);

draw_sprite_ext(spr_hair, type_hair, x, y, image_xscale * face, image_yscale, image_angle, color_multiply(image_blend, color_hair), alpha);
draw_sprite_ext(spr_cosmetic, type_cosmetic, x, y, image_xscale * face, image_yscale, image_angle, image_blend, alpha);
var aim = -_aim + (_recoil * (_reload / (game.run.reload * struct_default(game.WEAPON[abs(inventory[0])], "reload", game.DEFAULT_WEAPON))));
if (face == -1) aim += 180;
draw_sprite_ext(spr_weapon, abs(inventory[0]), x + (6 * face), y - 9, image_xscale * face, image_yscale, image_angle + aim, sign(inventory[0]) == 1 ? c_white : c_yellow, alpha);