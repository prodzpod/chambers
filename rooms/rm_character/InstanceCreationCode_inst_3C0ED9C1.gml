onchange = function (p) {
	player.color_arms = make_color_rgb(p * 255, color_get_green(player.color_arms), color_get_blue(player.color_arms));
}
label = "R";
value = color_get_red(game.save.color_arms) / 255;
onchange(value);