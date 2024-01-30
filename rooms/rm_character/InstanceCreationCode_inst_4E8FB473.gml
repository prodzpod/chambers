onchange = function (p) {
	player.color_shirt = make_color_rgb(color_get_red(player.color_shirt), p * 255, color_get_blue(player.color_shirt));
}
label = "G";
value = color_get_green(game.save.color_shirt) / 255;
onchange(value);