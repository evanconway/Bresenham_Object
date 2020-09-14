/// @description Insert description here
// You can write your code in this editor

if (keyboard_check_pressed(ord("D"))) {
	show_debug_message("Catch");
}

if (keyboard_check_pressed(ord("R"))) {
	game_restart();
}


var axis_x = gamepad_axis_value(0, gp_axislh)
var axis_y = gamepad_axis_value(0, gp_axislv);
var _vel_x = (abs(axis_x) > 0.2) ? axis_x : 0;
var _vel_y = (abs(axis_y) > 0.2) ? axis_y : 0;
var spd = 1.2;

if (keyboard_check(vk_up)) _vel_y -= spd;
if (keyboard_check(vk_down)) _vel_y += spd;
if (keyboard_check(vk_left)) _vel_x -= spd;
if (keyboard_check(vk_right)) _vel_x += spd;

var _angle = angle_from_vecs(_vel_x, _vel_y);
if (_angle >= 0) _angle = radtodeg(_angle);

// move object
if (_angle < 0) spd = 0;

approach(_angle, spd, o_wall);
/*
angle = _angle;
velocity = spd;
var changes = update_bresenham_line();
x += changes.change_x;
y += changes.change_y;
*/