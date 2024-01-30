onchange = function (p) {
	player.color_skin = make_color_rgb(p * 255, color_get_green(player.color_skin), color_get_blue(player.color_skin));
}
label = "R";
value = color_get_red(game.save.color_skin) / 255;
onchange(value);