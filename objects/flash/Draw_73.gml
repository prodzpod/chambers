var cam = view_get_camera(view_current);
var _x = camera_get_view_x(cam);
var _y = camera_get_view_y(cam);
var _w = camera_get_view_width(cam);
var _h = camera_get_view_height(cam);
draw_sprite_stretched_ext(spr_white, -1, _x, _y, _w, _h, color, alpha * _duration / duration);