event_inherited();
image_speed = 0;
if (room == rm_stage2) image_index = 1;
else if (room == rm_stage3) image_index = 2;
face = sign(vrandom(1));
states = {
	idle: {
		onstep: function(this, t) { with (this) {
			if (grounded && (place_meeting(x + face, y, block) || !place_meeting(x + face, y + 1, block)))
				face = -face;
			xspeed = SPEED * face;
			if (instance_exists(player) 
				&& distance_to_object(player) <= VIEW 
				&& collision_line(xcenter, ycenter, player.xcenter, player.ycenter, block, false, true) == noone) 
				changeState("alert");
		}}
	},
	alert: {
		duration: 0.5,
		onenter: function(this) { with (this) {
			aim = _aim;
			xspeed = 0;
			if (player.x != x) face = sign(player.x - x)			
		}},
		onend: function(this) { return "attack" },
	},
	attack: {
		duration: 2,
		onenter: function(this) { with(this) {
			xspeed += JUMP / 2 * dcos(aim);
			yspeed += JUMP * (dsin(aim) - 1) - 200;
		}}
	}
}
aim = 0;
SPEED = 120;
VIEW = 64;
JUMP = 200;
DAMAGE = 0.5;
_SPEED = 0;
_VIEW = 0;
_JUMP = 0;
_DAMAGE = 0;
state = states.idle;
hp = 5;
_HP = 0;
alarm[0] = 1;