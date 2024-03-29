event_inherited();
enemyID = object_get_name(slime);
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
ondeath = function() {
	var z = (image_xscale >= 3) ? slime2 : slime;
	with (instance_create_depth(x, y, depth, z)) {
		image_xscale = other.image_xscale / 2;
		image_yscale = other.image_yscale / 2;
		enemy_stun(self, 600, -45, 1);
	}
	with (instance_create_depth(x, y, depth, z)) {
		image_xscale = other.image_xscale / 2;
		image_yscale = other.image_yscale / 2;
		enemy_stun(self, 600, -135, 1);
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
hp = 10;
_HP = 0;
alarm[0] = 1;