if (!clicked) return;
if (keyboard_key != game.save.confirm && keyboard_key != game.save.cancel) {
	input = keyboard_string;
	ontype(input);
}