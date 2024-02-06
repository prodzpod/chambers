text = "Randomize"
onclick = function() {
	object_foreach(slider, function(this) {
		this.value = random(1);
		this.onchange(this.value);
	});
	player.type_hair = irandom(sprite_get_number(spr_hair) - 1);
	player.type_cosmetic = game.save.cosmetic_unlocks[irandom(array_length(game.save.cosmetic_unlocks) - 1)];
	with (instance_find(generic_input, 0)) {
		if (input != "") return;
		var _names = ["John Rogue", "Rogue Andy", "Little Timmy", "Big Jim", "Mysterious Figure", "Shadow Man", "Entity", "Being", "La Cretura", "Guy", "Person", "Big Hero 21", "Random Person", "Gearjohn Rogue Vansteam", "Gray47beard", "Elijah", "Z-Man"];
		input = array_random(_names);
		ontype(input);
	}
}