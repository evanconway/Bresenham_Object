/// @description Insert description here
// You can write your code in this editor

view_enabled = true;
view_visible[0] = true;
res = 100;
surface_resize(application_surface, res, res);
camera_set_view_size(view_camera[0], res, res);
window_m = 6;
window_set_size(res * window_m, res * window_m);
display_set_gui_size(res, res);
display_reset(0, true);

game_set_speed(60, gamespeed_fps);

event_inherited();
