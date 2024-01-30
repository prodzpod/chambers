var alpha = image_alpha;
if (stateName == "stunned" && _headbuttImmuneBlink) alpha = lerp(alpha, 0, 0.7);
else if (_headbuttImmune > 0 && _headbuttImmuneBlink) alpha = lerp(alpha, 0, _headbuttImmune / headbuttImmune);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);