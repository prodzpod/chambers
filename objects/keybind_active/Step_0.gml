if (mouse_check_button_pressed(mb_left)) onenter(mb_left);
else if (mouse_check_button_pressed(mb_middle)) onenter(mb_middle);
else if (mouse_check_button_pressed(mb_right)) onenter(mb_right);
else if (mouse_check_button_pressed(mb_side1)) onenter(mb_side1);
else if (mouse_check_button_pressed(mb_side2)) onenter(mb_side2);
else if (mouse_wheel_down()) onenter(mb_wheeldown);
else if (mouse_wheel_up()) onenter(mb_wheelup);