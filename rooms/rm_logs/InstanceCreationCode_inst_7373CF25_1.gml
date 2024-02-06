text = "View Logs"
toggle = false;
onclick = function() {
	toggle = !toggle;
	text = toggle ? "View Stats" : "View Logs";
	if (toggle) setup_logs(array_length(game.save.runs) - 1);
	else setup_stats();
}
disabled = array_length(game.save.runs) == 0;