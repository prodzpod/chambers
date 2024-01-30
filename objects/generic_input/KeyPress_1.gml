if (!clicked) return;
if (keyboard_key == vk_enter) {
	if (oninput(input)) {
		play_sfx(sfx_hat);
		input = "";
		keyboard_string = "";
	}
}
else {
	input = keyboard_string;
	ontype(input);
}