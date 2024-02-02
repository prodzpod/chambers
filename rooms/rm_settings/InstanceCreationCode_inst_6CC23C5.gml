label = "Screen\nshake"
value = game.save.shake / 2;
onchange = function(t) { game.save.shake = t * 2; screen_shake(2, 1); }