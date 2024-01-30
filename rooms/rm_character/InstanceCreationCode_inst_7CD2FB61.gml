onchange = function (p) {
	player.color_shirt = make_color_rgb(color_get_red(player.color_shirt), color_get_green(player.color_shirt), p * 255);
}
label = "B";
value = color_get_blue(game.save.color_shirt) / 255;
onchange(value);