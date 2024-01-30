onchange = function (p) {
	player.color_arms = make_color_rgb(color_get_red(player.color_arms), p * 255, color_get_blue(player.color_arms));
}
label = "G";
value = color_get_green(game.save.color_arms) / 255;
onchange(value);