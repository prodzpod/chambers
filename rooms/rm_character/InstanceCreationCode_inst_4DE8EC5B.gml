global.button_save = self;
text = "Save"
disabled = true;
onclick = function() {
	game.gameSpeed = 1;
	game.save.name = global.label_name.input;
	game.save.color_hair = player.color_hair;
	game.save.color_arms = player.color_arms;
	game.save.color_legs = player.color_legs;
	game.save.color_shirt = player.color_shirt;
	game.save.color_skin = player.color_skin;
	game.save.type_hair = player.type_hair;
	game.save.type_cosmetic = player.type_cosmetic;
	data_save();
	room_goto(rm_title);
}