onchange = function (p) {
	player.color_shirt = make_color_rgb(p * 255, color_get_green(player.color_shirt), color_get_blue(player.color_shirt));
}
label = "R";
value = color_get_red(game.save.color_shirt) / 255;
onchange(value);