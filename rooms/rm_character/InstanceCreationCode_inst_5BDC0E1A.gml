text = "Randomize"
onclick = function() {
	object_foreach(slider, function(this) {
		this.value = random(1);
		this.onchange(this.value);
	});
	player.type_hair = irandom(sprite_get_number(spr_hair) - 1);
	player.type_cosmetic = game.save.cosmetic_unlocks[irandom(array_length(game.save.cosmetic_unlocks) - 1)];
}