onchange = function (p) {
	player.color_skin = make_color_rgb(color_get_red(player.color_skin), p * 255, color_get_blue(player.color_skin));
}
label = "G";
value = color_get_green(game.save.color_skin) / 255;
onchange(value);