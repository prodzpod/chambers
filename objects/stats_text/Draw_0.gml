draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(x + 36, y + 36, game.save.name, c_white);
draw_text_outline(x + 48, y + 52, "Runs: " + string(game.save.wins + game.save.deaths), c_white);
draw_text_outline(x + 48, y + 68, "Wins: " + string(game.save.wins), c_white);
draw_text_outline(x + 48, y + 84, "Streak: " + string(game.save.streak), game.save.streak >= 0 ? c_white : c_red);
draw_text_outline(x + 48, y + 100, "PB: " + string(game.save.pb == "-1" ? "-:-:-.---" : format_time(game.save.pb)), game.save.pb == -1 ? c_gray : c_white);

var fw = 0;
var ks = struct_get_names(game.save.won_with); var v = 0;
for (var i = 0; i < array_length(ks); i++) if (v < game.save.won_with[$ ks[i]]) {
	v = game.save.won_with[$ ks[i]]; fw = ks[i];
}
var an = "None"; ks = struct_get_names(game.save.died_to); v = 0;
for (var i = 0; i < array_length(ks); i++) if (v < game.save.died_to[$ ks[i]]) {
	v = game.save.died_to[$ ks[i]]; an = ks[i];
}
var mc = "None"; ks = struct_get_names(game.save.running_as); v = 0;
for (var i = 0; i < array_length(ks); i++) if (v < game.save.running_as[$ ks[i]]) {
	v = game.save.running_as[$ ks[i]]; mc = ks[i];
}
var stc = c_white;
switch (mc) { case "Warrior": stc = c_red; break; case "Hunter": stc = c_lime; break; case "Mage": stc = c_aqua; break; };
var zw = string_width("Main Class: ");
draw_text_outline(x + 36, y + 132, "Main Class: ", c_white);
draw_text_outline(x + 36 + zw, y + 132, string(mc), stc);
zw = string_width("Favorite Weapon: ");
stc = [c_white, c_red, c_lime, c_aqua];
stc = stc[struct_default(game.WEAPON[fw], "class", game.DEFAULT_WEAPON)];
fw = struct_default(game.WEAPON[fw], "name", game.DEFAULT_WEAPON);
if (fw == "") fw = "None"
draw_text_outline(x + 36, y + 148, "Favorite Weapon: ", c_white);
draw_text_outline(x + 36 + zw, y + 148, fw, stc);
if (an == "") {
	zw = string_width("Arch Nemesis: ");
	var get_sprite = function(s) { return object_get_sprite(asset_get_index(string_split(s, "/")[1])); }
	var get_name = function(s2) { var s = string_split(s2, "/")[1]; return string_upper(string_char_at(s, 1)) + string_lower(string_copy(s, 2, string_length(s) - 1)); }
	var get_index = function(s) { return real(string_split(s, "/")[0]); }
	draw_text_outline(x + 36, y + 164, "Arch Nemesis: ", c_white);
	draw_sprite(get_sprite(an), get_index(an), x + 48 + zw, y + 184);
	draw_text_outline(x + 60 + zw, y + 164, string(get_name(an)), c_white);
}
draw_set_halign(fa_right);
draw_text_outline(x + 432, y + 52, "Weapon Logs: " + string(array_length(game.save.weapon_unlocks)) + "/" + string(sprite_get_number(spr_weapon)), c_white);
draw_text_outline(x + 432, y + 68, "Cosmetics: " + string(array_length(game.save.cosmetic_unlocks)) + "/" + string(sprite_get_number(spr_cosmetic)), c_white);
draw_text_outline(x + 432, y + 84, "ELO: " + string(game.save.elo), c_white);