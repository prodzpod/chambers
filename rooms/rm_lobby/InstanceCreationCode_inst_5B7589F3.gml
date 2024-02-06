image_index = 3;
if (array_length(game.run.cleared) != 0) instance_destroy();
onpickup = function () {
	game.run.class = 3;
	show_tutorial("Class Bonus", "You've just become either a Warrior, Hunter or a Mage. Each weapon has a corresponding class that does a stronger attack when you are of the same class (denoted by a plus sign), and sometimes can be gold and have more durability than usual.\n\nUse " + button_pretty(game.save.attack) + " to attack and " + button_pretty(game.save.reload) + " to throw weapons.");
}
grav = 0;