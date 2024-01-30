onchange = function (p) {
	player.color_hair = make_color_rgb(color_get_red(player.color_hair), color_get_green(player.color_hair), p * 255);
}
label = "B";
value = color_get_blue(game.save.color_hair) / 255;
onchange(value);