/// @description Insert description here
// You can write your code in this editor

if (keyboard_check_pressed(ord("D"))) {
	show_debug_message("Catch");
}

if (keyboard_check_pressed(ord("R"))) {
	game_restart();
}

var _vel_x = 0;
var _vel_y = 0;
var spd = 1.3;

var axis_x = gamepad_axis_value(0, gp_axislh)
var axis_y = gamepad_axis_value(0, gp_axislv);
var dead_zone = 0.2;

if (abs(axis_y) > dead_zone) _vel_y += axis_y * spd;
if (abs(axis_x) > dead_zone) _vel_x += axis_x * spd;

if (keyboard_check(vk_up)) _vel_y -= spd;
if (keyboard_check(vk_down)) _vel_y += spd;
if (keyboard_check(vk_left)) _vel_x -= spd;
if (keyboard_check(vk_right)) _vel_x += spd;

gui_angle = angle_from_vecs(_vel_x, _vel_y);
if (gui_angle >= 0) gui_angle = radtodeg(gui_angle);

if (gui_angle < 0) spd = 0;

// move object
if (true) {
	var mag = sqrt(sqr(_vel_y) + sqr(_vel_x));
	mag = clamp(mag, 0, spd);
	if (gui_angle < 0) mag = 0;
	move(gui_angle, mag, o_wall, o_wall2);
} else {
	x += _vel_x;
	y += _vel_y;
}
