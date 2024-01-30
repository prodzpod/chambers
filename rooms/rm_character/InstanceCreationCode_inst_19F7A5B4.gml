onchange = function(p) {
	player.type_cosmetic = pmod(player.type_cosmetic + p, sprite_get_number(spr_cosmetic));
	while (!array_contains(game.save.cosmetic_unlocks, player.type_cosmetic))
		player.type_cosmetic = pmod(player.type_cosmetic + p, sprite_get_number(spr_cosmetic));
}