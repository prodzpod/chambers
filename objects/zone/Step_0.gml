ds_list_clear(game.temp);
var length = instance_place_list(x, y, physics, game.temp, false);
var still_there = [];
for (var i = 0; i < length; i++) {
	var inst = game.temp[| i];
	if (inst.object_index != player && inst.object_index != enemy) continue; 
	array_push(still_there, inst);
	if (!array_contains(contained, inst)) onenter(inst);
}
for (var i = 0; i < array_length(contained); i++) {
	var inst = contained[i];
	if (!array_contains(still_there, inst)) onexit(inst);
}
contained = still_there;