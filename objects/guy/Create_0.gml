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
		duration: 0.25,
		onenter: function(this) { with (this) {
			aim = _aim;
			xspeed = 0;
			if (player.x != x) face = sign(player.x - x)			
		}},
		onend: function(this) { return "attack" },
	},
	attack: {
		duration: 0,
		onenter: function(this) { with(this) {
			bullet_spawn_ext(bullet, -1, 1, aim, JUMP, 15, 1, 0, false, false, c_yellow);
		}},
		onend: function(this) { return "recharge" },
	},
	recharge: {
		duration: 0.5,
		onstep: function(this, t) { with (this) {
			if (grounded && (place_meeting(x + face, y, block) || !place_meeting(x + face, y + 1, block)))
				face = -face;
			xspeed = SPEED * face;
		}}
	}
}
aim = 0;
SPEED = 60;
VIEW = 192;
JUMP = 200;
state = states.idle;
headbuttDamage = 0.1;