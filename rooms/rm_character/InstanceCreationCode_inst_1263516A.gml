onchange = function (p) {
	player.color_legs = make_color_rgb(color_get_red(player.color_legs), color_get_green(player.color_legs), p * 255);
	player.color_legr = make_color_hsv(color_get_hue(player.color_legs), color_get_saturation(player.color_legs), color_get_value(player.color_legs) * player.COLOR_LEGS_SHADE);
}
label = "B";
value = color_get_blue(game.save.color_legs) / 255;
onchange(value);