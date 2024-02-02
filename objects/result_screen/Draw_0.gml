draw_set_color(c_black);
draw_sprite_stretched_ext(spr_white, -1, x + 32, y + 32, 480 - 64, 270 - 64, c_black, 0.5);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(x + 36, y + 36, success ? "We're so back" : "It's so over", c_white);
