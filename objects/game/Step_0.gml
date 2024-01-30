/// @description physacs
global.t = delta_time * gameSpeed / 1000000;
run.rta += delta_time / 1000000;
run.igt += global.t;

_cameraOffX = keyboard_check(ord("D")) - keyboard_check(ord("A"));
_cameraOffY = keyboard_check(ord("S")) - keyboard_check(ord("W"));
if (!keyboard_check(vk_shift)) { _cameraOffX = 0; _cameraOffY = 0; }
__cameraOffX = lerp(__cameraOffX, _cameraOffX, 0.1);
__cameraOffY = lerp(__cameraOffY, _cameraOffY, 0.1);

object_foreach(physics, function(this) {
	with (this) {
		yspeed += global.t * grav;
		onstep(global.t);
		var sig = sign(xspeed);
		var tomove = floor(abs(xspeed * global.t)) * sig;
		xsub += (xspeed * global.t) % 1
		if (xsub < 0) { tomove -= 1; xsub += 1; }
		if (xsub > 1) { tomove += 1; xsub -= 1; }
		for (var i = 0; i < abs(tomove) - 1; i++) {
			if (place_meeting(x + sig, y, block)) { if (xspeed * sig > 0) xspeed = 0; break; };
			x += sig;
		}
		sig = sign(yspeed);
		tomove = floor(abs(yspeed * global.t)) * sig;
		ysub += (yspeed * global.t) % 1
		if (ysub < 0) { tomove -= 1; ysub += 1; }
		if (ysub > 1) { tomove += 1; ysub -= 1; }
		for (var i = 0; i < abs(tomove) - 1; i++) {
			grounded = false;
			if (place_meeting(x, y + sig, block) || (sig > 0 && instance_position(x, y + sig, semisolid))) { 
				if (yspeed * sig > 0) {
					if (sig > 0) {
						onground(yspeed);
						grounded = true;
					}
					yspeed = 0;
				} break; 
			}
			y += sig;
		}
	}
});

object_foreach(bullet, function(this) {
	var checkBullet = function(this) { with (this) {
		ds_list_clear(game.temp);
		instance_place_list(x, y, friendly ? enemy : player, game.temp, false);
		filter(game.temp, function(x) { return !array_contains(affected, x); });
		for (var i = 0; i < ds_list_size(game.temp); i++) {
			var inst = game.temp[| i];
			if (friendly) enemy_damage(self, inst, damage);
			else player_damage(parent, damage);
			if (!piercing) instance_destroy(this);
			array_push(affected, inst);
		}
		if (cancel_priority > 0) { // bullet can cancel things
			ds_list_clear(game.temp);
			instance_place_list(x, y, bullet, game.temp, false);
			filter(game.temp, function(x) { return !array_contains(affected, x); });
			for (var i = 0; i < ds_list_size(game.temp); i++) {
				var inst = game.temp[| i];
				if (inst.friendly != friendly) {
					var h = inst.cancel_priority;
					if (h <= cancel_priority) instance_destroy(inst);
					if (h >= cancel_priority) instance_destroy(this);
				}
				array_push(affected, inst);
			}
		}
	}}
	with (this) {
		onstep(global.t);
		var sig = sign(xspeed);
		var tomove = floor(abs(xspeed * global.t)) * sig;
		xsub += (xspeed * global.t) % 1
		if (xsub < 0) { tomove -= 1; xsub += 1; }
		if (xsub > 1) { tomove += 1; xsub -= 1; }
		for (var i = 0; i < abs(tomove) - 1; i++) {
			if (!spectral && place_meeting(x + sig, y, block)) {
				if (!onbounce(sig == 1 ? 0 : 180)) instance_destroy();
			}
			x += sig;
			checkBullet(this);
		}
		sig = sign(yspeed);
		tomove = floor(abs(yspeed * global.t)) * sig;
		ysub += (yspeed * global.t) % 1
		if (ysub < 0) { tomove -= 1; ysub += 1; }
		if (ysub > 1) { tomove += 1; ysub -= 1; }
		for (var i = 0; i < abs(tomove) - 1; i++) {
			if (!spectral && (place_meeting(x, y + sig, block) || (sig > 0 && instance_position(x, y + sig, semisolid)))) {
				if (!onbounce(sig == 1 ? 90 : -90)) instance_destroy();
			}
			y += sig;
			checkBullet(this);
		}		
		checkBullet(this);
		life -= global.t;
		if (life <= 0) instance_destroy();
	}
});

object_foreach(delay, function(this) { this.time -= global.t; if (this.time <= 0) { this.onalarm(); instance_destroy(this); } })

if (instance_exists(player)) {
	while (player.x < cameraX) cameraX -= 480;
	while ((cameraX + 480) < player.x) cameraX += 480;
	while (player.y < cameraY) cameraY -= 270;
	while ((cameraY + 270) < player.y) cameraY += 270;
}

if (_screenshakeDuration > 0) {
	_screenshakeDuration -= delta_time / 1000000;
}

if (_tooltipDuration > 0) {
	_tooltipDuration -= delta_time / 1000000;
}

if (instance_exists(boss) && cameraX <= boss.x && boss.x <= cameraX + 480 && cameraY <= boss.y && boss.y <= cameraY + 270) {
	if (shouldActivateBoss > 0) {
		shouldActivateBoss -= global.t;
		if (shouldActivateBoss <= 0) {
			boss.activate = true;
			play_sfx(sfx_snare);
			play_bgm(bgm_boss);
		}
	}
} else shouldActivateBoss = 5;