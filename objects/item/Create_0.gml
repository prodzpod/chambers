event_inherited();
image_speed = 0;
type = 0;
alarm[0] = 1;
__r = random(360);
onstep = function(t) { 
	if (grounded) xspeed = lerp(xspeed, 0, 0.5); 
}