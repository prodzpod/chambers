event_inherited();
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
			xspeed += JUMP * dcos(aim);
			yspeed += JUMP * (dsin(aim) - 1);
		}}
	}
}
aim = 0;
SPEED = 120;
VIEW = 64;
JUMP = 200;
DAMAGE = 0.25;
_SPEED = 0;
_VIEW = 0;
_JUMP = 0;
_DAMAGE = 0;
state = states.idle;
hp = 5;
_HP = 0;
alarm[0] = 1;