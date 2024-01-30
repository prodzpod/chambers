if (_durability != 0) durability = _durability;
else {
	durability = struct_default(game.WEAPON[pmod(image_index, array_length(game.WEAPON))], "durability", game.DEFAULT_WEAPON);
	if (image_blend != c_white) durability *= 10;
}