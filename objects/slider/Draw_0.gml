draw_self();
draw_sprite_ext(spr_slider, -1, x + (value * (bbox_right - bbox_left)), y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x - 16, y, label);