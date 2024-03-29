event_inherited();
enemyID = object_get_name(guy);
image_speed = 0;
if (room == rm_stage2) image_index = 1;
else if (room == rm_stage3) image_index = 2;
face = sign(vrandom(1));
states = {
	idle: {
		onstep: function(this, t) { with (this) {
			if (grounded && (place_meeting(x + face, y, block) || !place_meeting(x + face, y + 1, block)))
				face = -face;
			if (random(1) < 0.1) face = -face;
			xspeed = SPEED * face;
			if (instance_exists(player) 
				&& distance_to_object(player) <= VIEW 
				&& collision_line(xcenter, ycenter, player.xcenter, player.ycenter, block, false, true) == noone) 
				changeState("alert");
			if (jump) { jump = false; yspeed = -400; }
		}}
	},
	alert: {
		duration: 0.5,
		onenter: function(this) { with (this) {
			aim = _aim;
			xspeed = SPEED * face;
			if (jump) { jump = false; yspeed = -400; }
			if (player.x != x) face = sign(player.x - x)			
		}},
		onend: function(this) { return "attack" },
	},
	attack: {
		duration: 0,
		onenter: function(this) { with(this) {
			bullet_spawn_ext(bullet, -1, 1, aim, JUMP, 15, 1, 0, false, false, c_yellow);
			play_sfx(sfx_hat3);
		}},
		onend: function(this) { return "recharge" },
	},
	recharge: {
		duration: 0.75,
		onstep: function(this, t) { with (this) {
			if (grounded && (place_meeting(x + face, y, block) || !place_meeting(x + face, y + 1, block)))
				face = -face;
			xspeed = SPEED * face;
		}}
	}
}
aim = 0;
jump = true;
onground = function() { jump = true; }
SPEED = 100;
VIEW = 192;
hp = 5;
JUMP = 200;
state = states.idle;
headbuttDamage = 0.5;