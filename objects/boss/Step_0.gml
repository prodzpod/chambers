event_inherited();
if (instance_exists(player)) distp = distance_to_object(player);
distb = -1;
for (var i = 0; i < instance_number(bullet); i++) {
	var inst = instance_find(bullet, i);
	if (!inst.friendly) continue;
	var d = distance_to_object(inst);
	if (distb == -1 || distb > d) {
		distb = d;
		aimb = darctan2(inst.y - ycenter, inst.x - xcenter);
	}
}