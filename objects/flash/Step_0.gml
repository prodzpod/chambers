_duration -= delta_time / 1000000;
if (_duration <= 0) instance_destroy();
if (instance_exists(player)) { x = player.x; y = player.y; }