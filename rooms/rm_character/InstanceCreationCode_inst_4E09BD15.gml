onchange = function(p) {
	player.type_hair = pmod(player.type_hair + p, sprite_get_number(spr_hair));
}