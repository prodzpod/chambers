event_inherited();
image_speed = 0;
image_angle = 90;
durability = 0;
_durability = 0;
alarm[0] = 1;
__r = random(360);
onstep = function(t) { 
	if (grounded) xspeed = lerp(xspeed, 0, 0.5); 
	if (image_blend != c_white && random(1) < 0.2) particle_spawn(1, x, y);
}
onpickup = function() {}