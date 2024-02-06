text = "Reset Tutorial";
onclick = function() {
	game.save.seentutorial = [];
	array_remove(game.save.cosmetic_unlocks, 5);
}