text = "View Weapons"
toggle = false;
onclick = function() {
	toggle = !toggle;
	text = toggle ? "View Cosmetics" : "View Weapons";
	setup_compendium(toggle ? spr_weapon : spr_cosmetic, 0);
}