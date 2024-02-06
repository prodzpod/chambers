_life -= delta_time / 1000000;
if (_life <= 0) instance_destroy();
image_alpha = dsin(180 * _life / life);
if (instance_exists(player)) { x = player.x; y = player.y; }