switch (type) {
	case 0:
		game.run.hp++;
		if (game.run.hp >= 15) array_push(game.run.cosmetic_unlocks, 11);
		show_tooltip("+Health", 1);
		break;
	case 1:
		game.run.shield++;
		show_tooltip("+Shield", 1);
		break;
	case 2:
		game.run.immunity += 0.5;
		show_tooltip("+Immunity", 1);
		break;
	case 3:
		game.run.durability[0] += max(1, floor(stat("durability") / 3));
		show_tooltip("+Repair", 1);
		break;
	case 4:
		game.run.jump += 25;
		show_tooltip("+Jump", 1);
		break;
	case 5:
		game.run.move += 25;
		show_tooltip("+Speed", 1);
		break;
	case 6:
		game.run.mystery++;
		show_tooltip("+Mystery", 1);
		break;
	case 7:
		game.run.multishot += 0.05;
		show_tooltip("+Multishot", 1);
		break;
	case 8:
		game.run.maxdmg += 0.25;
		show_tooltip("+Critical", 1);
		break;
	case 9:
		game.run.mindmg += 0.25;
		show_tooltip("+Damage", 1);
		break;
}
onpickup();