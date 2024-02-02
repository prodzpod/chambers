bind = instance_create_depth(x + 32, y, 0, generic_button);
var unset = instance_create_depth(x + 100, y, 0, generic_button);
unset.parent = self; bind.parent = self;
unset.text = "Unset";
bind.text = button_pretty(game.save[$ key]);
bind.key = key;
unset.onclick = function() { play_sfx(sfx_afuche); game.save[$ key] = vk_nokey; bind.text = button_pretty(game.save[$ key]); };
bind.onclick = function() { with (instance_create_depth(x, y, -1, keybind_active)) { self.button = other.bind; self.key = other.key; }}