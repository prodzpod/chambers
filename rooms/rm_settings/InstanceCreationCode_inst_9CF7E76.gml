text = "Peek Mode: Move";
global.temp = 0;
onclick = function() {
	game.save.peekwithaim = !game.save.peekwithaim
	text = game.save.peekwithaim ? "Peek Mode: Aim" : "Peek Mode: Move"
}