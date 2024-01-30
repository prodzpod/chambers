global.label_name = self;
placeholder = "Name..."
ontype = function(i) {
	global.button_save.disabled = (i == "");
}
input = game.save.name;
ontype(input);