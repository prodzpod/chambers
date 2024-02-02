event_inherited();
image_speed = 0;
if (room == rm_stage2) image_index = 1;
else if (room == rm_stage2) image_index = 2;
q = 0;
face = sign(vrandom(1));
states = {
	idle: {
		onstep: function(this, t) { with (this) {
			if (grounded && (place_meeting(x + face, y, block) || !place_meeting(x + face, y + 1, block)))
				face = -face;
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
			yspeed -= JUMP
			if (player.x != x) face = sign(player.x - x)			
		}},
		onend: function(this) { return "attack" },
	},
	attack: {
		duration: 1.5,
		onenter: function(this) { with(this) {
			yspeed += JUMP
			play_sfx(sfx_kick);
			q += 45;
			bullet_spawn_ext(bullet_fading, 0.25, DAMAGE, image_angle + q, 150, 0, image_xscale, 2, true, true, c_white, spr_spike); 
			bullet_spawn_ext(bullet_fading, 0.25, DAMAGE, image_angle + q + 90, 150, 0, image_xscale, 2, true, true, c_white, spr_spike); 
			bullet_spawn_ext(bullet_fading, 0.25, DAMAGE, image_angle + q + 180, 150, 0, image_xscale, 2, true, true, c_white, spr_spike); 
			bullet_spawn_ext(bullet_fading, 0.25, DAMAGE, image_angle + q + 270, 150, 0, image_xscale, 2, true, true, c_white, spr_spike); 
		}}
	}
}
aim = 0;
VIEW = 64;
JUMP = 400;
DAMAGE = 0.5;
_SPEED = 0;
_VIEW = 0;
_JUMP = 0;
_DAMAGE = 0;
state = states.idle;
hp = 10;
_HP = 0;
alarm[0] = 1;