if (mouse_check_button_pressed(mb_left) || input_check_pressed(game.save.cancel)) {
	clicked = false;
	game.input_clicked = false;
}
if (!game.input_clicked && input_check_pressed(game.save.confirm)) {
	clicked = true;
	game.input_clicked = true;
}
if (clicked && input_check_pressed(game.save.confirm)) {
	if (oninput(input)) {
		input = "";
		keyboard_string = "";
	}
	play_sfx(sfx_hat);
}