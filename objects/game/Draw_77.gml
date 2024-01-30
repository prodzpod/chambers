/// @description Insert description here
if (os_browser == browser_not_a_browser) {
	shader_set(sdr_bloom);
	u_pixels = [u_pixel / window_get_width(), u_pixel / window_get_height()];
	shader_set_uniform_f_array(_u_quality, u_quality);
	shader_set_uniform_f_array(_u_color, u_color);
	shader_set_uniform_f(_u_threshold, u_threshold);
	shader_set_uniform_f_array(_u_pixels, u_pixels);
}
var w = window_get_width();
var h = window_get_height();
var res = min(w / 480, h / 270);

draw_surface_stretched(application_surface, (w - (480 * res)) / 2, (h - (270 * res)) / 2, 480 * res, 270 * res);
if (os_browser == browser_not_a_browser) shader_reset();