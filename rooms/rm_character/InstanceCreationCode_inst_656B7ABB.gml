onchange = function (p) {
	player.color_skin = make_color_rgb(color_get_red(player.color_skin), color_get_green(player.color_skin), p * 255);
}
label = "B";
value = color_get_blue(game.save.color_skin) / 255;
onchange(value);