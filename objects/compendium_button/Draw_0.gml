draw_sprite_ext(spr_player, 1, x, y, image_xscale, image_yscale, image_angle, color_multiply(image_blend, game.save.color_skin), image_alpha);
draw_sprite_ext(spr_player, 2, x, y, image_xscale, image_yscale, image_angle, color_multiply(image_blend, game.save.color_shirt), image_alpha);
draw_sprite_ext(spr_player, 3, x, y, image_xscale, image_yscale, image_angle, color_multiply(image_blend, game.save.color_arms), image_alpha);
draw_sprite_ext(spr_player, 4, x, y, image_xscale, image_yscale, image_angle, color_multiply(image_blend, game.save.color_legs), image_alpha);
draw_sprite_ext(spr_player, 5, x, y, image_xscale, image_yscale, image_angle, color_multiply(image_blend, make_color_hsv(color_get_hue(game.save.color_legs), color_get_saturation(game.save.color_legs), color_get_value(game.save.color_legs) * 0.5)), image_alpha);
draw_sprite_ext(spr_hair, game.save.type_hair, x, y, image_xscale, image_yscale, image_angle, color_multiply(image_blend, game.save.color_hair), image_alpha);
draw_sprite_ext(spr_cosmetic, spr == spr_cosmetic ? idx : game.save.type_cosmetic, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
if (spr != spr_cosmetic) draw_sprite_ext(spr, idx, x + 12, y - 18, image_xscale, image_yscale, image_angle, image_blend, image_alpha);