if (label != "") {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var color = make_color_hsv(h, s, v);
	draw_set_font(global.fnt_small);
	draw_text_transformed_color(x, y, label, size, size, angle, color, color, color, color, alpha);
	draw_set_font(fnt_alagard);
} else draw_sprite_ext(sprite_index, image_index, x, y, size, size, angle, make_color_hsv(h, s, v), alpha);