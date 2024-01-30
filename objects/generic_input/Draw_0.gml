draw_self();
var empty = !clicked && input == "";
draw_set_color(empty ? c_gray : c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle); 
draw_text(x, y, empty ? placeholder : input);