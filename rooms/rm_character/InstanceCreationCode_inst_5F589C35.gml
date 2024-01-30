onchange = function (p) {
	player.color_arms = make_color_rgb(color_get_red(player.color_arms), color_get_green(player.color_arms), p * 255);
}
label = "B";
value = color_get_blue(game.save.color_arms) / 255;
onchange(value);