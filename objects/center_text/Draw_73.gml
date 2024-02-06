var w = min(320, string_width(label));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_ext_color(game.cameraX + 240, game.cameraY + 60, label, 16, 320, image_blend, image_blend, image_blend, image_blend, image_alpha);
draw_sprite_stretched_ext(spr_white, -1, game.cameraX + 240 + 8 - (w / 2), game.cameraY + 66, w - 16, 1, image_blend, image_alpha / 2);
draw_sprite_ext(spr_wing, -1, game.cameraX + 240 - (w / 2) - 8, game.cameraY + 60, 1, 1, 0, image_blend, image_alpha);
draw_sprite_ext(spr_wing, -1, game.cameraX + 240 + (w / 2) + 8, game.cameraY + 60, -1, 1, 0, image_blend, image_alpha);