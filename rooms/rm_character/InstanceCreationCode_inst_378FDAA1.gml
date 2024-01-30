onchange = function (p) {
	player.color_hair = make_color_rgb(p * 255, color_get_green(player.color_hair), color_get_blue(player.color_hair));
}
label = "R";
value = color_get_red(game.save.color_hair) / 255;
onchange(value);