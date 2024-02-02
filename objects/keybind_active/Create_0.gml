key = "";
button = noone;
function onenter(r) {
	game.save[$ key] = r;
	button.text = button_pretty(game.save[$ key]);
	play_sfx(sfx_snare);
	instance_destroy();
}