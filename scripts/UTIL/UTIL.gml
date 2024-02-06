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
	var _x = window_get_x() + (window_get_width() / 2) - (240 * game.save.resolution);
	var _y = window_get_y() + (window_get_height() / 2) - (135 * game.save.resolution);
	window_set_rectangle(_x, _y, 480 * game.save.resolution, 270 * game.save.resolution);
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
	with (instance_create_depth(0, 0, 0, delay)) { time = duration; onalarm = fn; if (instance_exists(player)) { x = player.x; y = player.y; } }
}

function wheel_check(key) {
	if (key == mb_wheelup) return mouse_wheel_up();
	if (key == mb_wheeldown) return mouse_wheel_down();
	return -1; // not a wheel key
}

function key_is_mouse(key) {
	return key == mb_left
		|| key == mb_right
		|| key == mb_middle
		|| key == mb_side1
		|| key == mb_side2;
}

function generic_check(key, fn_keyboard, fn_mouse) {
	var ret = wheel_check(key);
	if (ret != -1) return ret;
	if (key_is_mouse(key)) return fn_mouse(key);
	else return fn_keyboard(key);
}

function input_check(key, neg=-1) {
	var ret = generic_check(key, keyboard_check, mouse_check_button);
	if (neg != -1) ret -= generic_check(neg, keyboard_check, mouse_check_button);
	return ret;
}

function input_check_pressed(key, neg=-1) {
	var ret = generic_check(key, keyboard_check_pressed, mouse_check_button_pressed);
	if (neg != -1) ret -= generic_check(neg, keyboard_check_pressed, mouse_check_button_pressed);
	return ret;
}

function input_check_released(key, neg=-1) {
	var ret = generic_check(key, keyboard_check_released, mouse_check_button_released);
	if (neg != -1) ret -= generic_check(neg, keyboard_check_released, mouse_check_button_released);
	return ret;
}

function button_pretty(key) {
	switch (key) {
		case vk_nokey:
			return "NONE";
		case mb_left: return "LMB";
		case mb_right: return "RMB";
		case mb_middle: return "MMB";
		case mb_side1: return "MS1";
		case mb_side2: return "MS2";
		case mb_wheelup: return "MWU";
		case mb_wheeldown: return "MWD";
		case vk_add: return "+";
		case vk_alt: return "ALT";
		case vk_backspace: return "BKSP";
		case vk_control: return "CTRL";
		case vk_decimal: return ".";
		case vk_delete: return "DEL";
		case vk_divide: return "/";
		case vk_down: return "DOWN";
		case vk_up: return "UP";
		case vk_right: return "RIGHT";
		case vk_left: return "LEFT";
		case vk_end: return "END";
		case vk_enter: return "ENTER";
		case vk_escape: return "ESC";
		case vk_f1: return "F1";
		case vk_f2: return "F2";
		case vk_f3: return "F3";
		case vk_f4: return "F4";
		case vk_f5: return "F5";
		case vk_f6: return "F6";
		case vk_f7: return "F7";
		case vk_f8: return "F8";
		case vk_f9: return "F9";
		case vk_f10: return "F10";
		case vk_f11: return "F11";
		case vk_f12: return "F12";
		case vk_home: return "HOME";
		case vk_insert: return "INS";
		case vk_lalt: return "ALT";
		case vk_lcontrol: return "CTRL";
		case vk_lshift: return "SHIFT";
		case vk_multiply: return "*";
		case vk_numpad9: return "9";
		case vk_numpad8: return "8";
		case vk_numpad7: return "7";
		case vk_numpad6: return "6";
		case vk_numpad5: return "5";
		case vk_numpad4: return "4";
		case vk_numpad3: return "3";
		case vk_numpad2: return "2";
		case vk_numpad1: return "1";
		case vk_numpad0: return "0";
		case vk_pagedown: return "PGDN";
		case vk_pageup: return "PGUP";
		case vk_printscreen: return "PRNT";
		case vk_ralt: return "ALT";
		case vk_rcontrol: return "CTRL";
		case vk_rshift: return "SHIFT";
		case vk_shift: return "SHIFT";
		case vk_space: return "SPACE";
		case vk_subtract: return "-";
		case vk_tab: return "TAB";
		default: return chr(key);
	}
}

function flash_screen(dur, a, col=c_white) {
	with (instance_create_depth(0, 0, -100, flash)) { duration = dur; alpha = a; color = col; if (instance_exists(player)) { x = player.x; y = player.y; } }
}

function elo_calculate(elo, opponent, won) {
	var k = 100;
	var p = (1 / (1.0 + power(10, ((opponent - elo) / 400))));
	return k * ((won ? 1 : 0) - p) + elo;
}

function date_timestamp(date) {
	if (is_undefined(date)) date = date_current_datetime();
	return floor(date_second_span(date_create_datetime(1990, 1, 1, 0, 0, 0), date)) + 631152000;
}

function date_from_timestamp(timestamp) {
	var t = date_inc_second(25569+1, timestamp);
	return date_inc_day(t, -1);
}

function base64_encode_safe(s) {
	return string_replace_all(string_replace_all(string_replace_all(base64_encode(s), "+", "."), "/", "-"), "=", "_");
}

function base64_decode_safe(s) {
	return base64_decode(string_replace_all(string_replace_all(string_replace_all(s, ".", "+"), "-", "/"), "_", "="));
}
	
function struct_nullish(struct, id, def=0) { if (!struct_exists(struct, id)) struct[$ id] = def; }

function array_remove(arr, value, amount=1) { var i = array_get_index(arr, value); if (i != -1) array_delete(arr, i, amount); }

function color_multiply(c1, c2) { return make_color_rgb(color_get_red(c1) * color_get_red(c2) / 255, color_get_green(c1) * color_get_green(c2) / 255, color_get_blue(c1) * color_get_blue(c2) / 255); }

function format_time(t) {  
	var ms = floor((t % 1) * 1000);
	var s = floor(t) % 60;
	var m = floor(t / 60) % 60; 
	var h = floor(t / 3600); 
	return string_join_ext(":", array_map([h, m, s], string)) + "." + string(ms);
}

function format_date(t) {
	var d = date_from_timestamp(t);
	return string_join_ext("-", array_map([date_get_year(d), date_get_month(d), date_get_day(d)], string));
}