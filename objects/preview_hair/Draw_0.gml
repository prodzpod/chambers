draw_sprite_ext(spr_hair, player.type_hair, x, y, image_xscale, image_yscale, image_angle, player.color_hair, image_alpha);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_set_valign(fa_top);
draw_text(x, y - 8, "Type " + string(player.type_hair));
draw_text(x, y + 16, "Hair Color");
draw_set_valign(fa_bottom);
draw_text(x, y - 48, "Hair");