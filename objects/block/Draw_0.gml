var xx = abs(image_xscale);
var yy = abs(image_yscale);
if (min(xx, yy) >= 4 * (15/16))
	draw_sprite_ext(global.tileset[0], image_index, x, y, image_xscale / 4, image_yscale / 4, image_angle, image_blend, image_alpha);
else if (min(xx, yy) >= 2 * (15/16))
	draw_sprite_ext(global.tileset[1], image_index, x, y, image_xscale / 2, image_yscale / 2, image_angle, image_blend, image_alpha);
else draw_sprite_ext(global.tileset[2], image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);