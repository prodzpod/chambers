text = "Online Mode: On";
onclick = function() {
	game.save.online = !game.save.online;
	text = game.save.online ? "Online Mode: On" : "Online Mode: Off";
}