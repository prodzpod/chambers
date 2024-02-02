text = "Resolution: " + string_pretty(game.save.resolution) + "x";
onclick = function() {
	var _res = min(display_get_width() / 480, display_get_height() / 270);
	if (game.save.resolution == _res) game.save.resolution = 1;
	else game.save.resolution = min(game.save.resolution + 1, _res);
	window_apply_resolution();
	text = "Resolution: " + string_pretty(game.save.resolution) + "x";
}