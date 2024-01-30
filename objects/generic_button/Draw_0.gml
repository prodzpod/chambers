draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
w = string_width(text);
draw_sprite_ext(spr_button, -1, x, y, image_xscale, image_yscale, image_angle, disabled ? c_gray : c_white, image_alpha);
draw_text(x, y, text);