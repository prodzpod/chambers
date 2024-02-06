text = "Skip Tutorial";
onclick = function() {
	game.save.seentutorial = [
	    "Welcome to the Chambers",
	    "Class Bonus",
	    "Stale and Durability",
	    "Throwing",
	    "Compendium",
	    "Peeking",
	    "Unlocking Chests"
	];
	array_push(game.save.cosmetic_unlocks, 5);
}