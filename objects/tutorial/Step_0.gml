if (temp <= 0 && (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))) {
	play_sfx(sfx_afuche);
	game.gameSpeed = time;
	instance_destroy();
}
temp -= delta_time / 1000000;
if (instance_exists(player)) { x = player.x - pmod(player.x, 480); y = player.y - pmod(player.y, 270); }