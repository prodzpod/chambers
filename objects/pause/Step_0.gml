if (input_check_pressed(game.save.cancel)) {
	play_sfx(sfx_afuche);
	game.gameSpeed = time;
	audio_resume_sound(game.bgm);
	instance_destroy();
}