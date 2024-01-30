// COPIED FROM STARTELLERS

function log() {
	txt = "";
	for (var i = 0; i < argument_count; i++) txt += string(argument[i]) + " ";
	show_debug_message(txt);
}

function draw_log() {
	txt = "";
	for (var i = 0; i < argument_count; i++) txt += string(argument[i]) + " ";
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_text(x, y, txt)
}

function log_list(list) {
	txt = "";
	for (var i = 0; i < ds_list_size(list); i++) txt += string(list[| i]) + " ";
	show_debug_message(txt);	
}

function object_foreach(obj, fn) {
	for (var i = 0; i < instance_number(obj); i++) fn(instance_find(obj, i));
}

function dist(x, y) {
	return sqrt(sqr(x) + sqr(y));
}

function project(x, y, a) {
	return dot_product(x, y, dcos(a), dsin(a));
}

function rotateAround(x, y, ox, oy, a) {
	var _x = x - ox;
	var _y = y - oy;
	var _r = dist(_x, _y);
	var _a = darctan2(_y, _x);
	return {x: _r * dcos(_a + a), y: _r * dsin(_a + a)};
}

function onlyMoveDirection(fromX, fromY, toX, toY, a) {
	var m = max(abs(dcos(a)), abs(dsin(a)))
	return { x: lerp(fromX, toX, abs(dcos(a)) / m), y: lerp(fromY, toY, abs(dsin(a)) / m) };
}

function pmod(n, a) { // mod that guarantees positiveness
	return ((n % a) + a) % a;
}

function angleDifference(a, b) { // a + angleDifference(a, b) = b;
	a = pmod(a, 360); b = pmod(b, 360);
	if (abs(b - a) <= 180) return b - a;
	if (a > b) a -= 360; else b -= 360;
	return b - a;
}

function angleFace(a, b) { // 1: similar angle, 0: right angle, -1: opposite angle
	return ssign(dot_product(dcos(a), dsin(a), dcos(b), dsin(b)));
}

function any(id, fn) {
	var length = ds_list_size(id);
	for (var i = 0; i < length; i++) if (fn(id[| i], i, id)) return true;
	return false;
}

function filter(id, fn) {
	ds_list_clear(game._list);
	var length = ds_list_size(id);
	for (var i = 0; i < length; i++) if (fn(id[| i], i, id)) ds_list_add(game._list, id[| i]);
	ds_list_clear(id);
	length = ds_list_size(game._list);
	for (var i = 0; i < length; i++) ds_list_add(id, game._list[| i]);
	return length;
}

function map(id, fn) {
	var length = ds_list_size(id);
	for (var i = 0; i < length; i++) fn(id[| i], i, id);
}

function l(s) {
	// localization...
	return s;
}

function ssign(n) { // safe sign
	if (abs(n) < 0.01) return 0;
	return sign(n);
}

function glow(radius, color = c_white, intensity = 1, skip = 1, shape = sprite_index, subimg = image_index, _x = x, _y = y, xscale = image_xscale, yscale = image_yscale, rot = image_angle) {
	gpu_set_fog(true, color, 0, 0);
	gpu_set_blendmode(bm_add);
	var w = max(1, sprite_get_bbox_right(shape) - sprite_get_bbox_left(shape));
	var h = max(1, sprite_get_bbox_bottom(shape) - sprite_get_bbox_top(shape));
	var p = intensity * (skip / radius);
	for (var i = 0; i < radius; i += skip) {
		var _w = ((w * abs(xscale)) + (i * 2)) / w;
		if (xscale < 0) _w *= -1;
		var _h = ((h * abs(yscale)) + (i * 2)) / h;
		if (yscale < 0) _h *= -1;
		draw_sprite_ext(shape, subimg, _x, _y, _w, _h, rot, c_white, p);
	}
	gpu_set_blendmode(bm_normal);
	gpu_set_fog(false, c_white, 0, 0);
}

function vrandom(a) {
	return random(a) - (a / 2);
}

function window_apply_resolution() {
	window_set_rectangle(window_get_x() - 240 * (save.resolution - 1), window_get_y() - 135 * (save.resolution - 1), 480 * save.resolution, 270 * save.resolution);
}

function isPlayer(target) { 
	return target.object_index == player; 
}

function struct_default(struct, key, def) {
	if (struct_exists(struct, key)) return struct[$ key];
	return def[$ key];
}

function draw_text_outline(x, y, str, color) {
	draw_set_color(c_black);
	draw_text(x - 1, y - 1, str);
	draw_text(x - 1, y, str);
	draw_text(x - 1, y + 1, str);
	draw_text(x + 1, y - 1, str);
	draw_text(x + 1, y, str);
	draw_text(x + 1, y + 1, str);
	draw_text(x, y - 1, str);
	draw_text(x, y + 1, str);
	draw_set_color(color);
	draw_text(x, y, str);
}

function array_random(arr) {
	return arr[irandom(array_length(arr) - 1)];
}

function timeout(duration, fn) {
	with (instance_create_depth(0, 0, 0, delay)) { time = duration; onalarm = fn; }
}