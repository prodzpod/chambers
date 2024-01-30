draw_sprite_ext(spr_cosmetic, player.type_cosmetic, x, y + 16, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_set_valign(fa_top);
draw_text(x, y, game.COSMETICS[player.type_cosmetic].name);
draw_text(x, y + 24, "Skin Color");
draw_set_valign(fa_bottom);
draw_text(x, y - 48, "Cosmetics");