
gui_angle = 0;
res = 100;
window_m = 8;

view_visible[0] = true;
view_enabled = true;

alarm[0] = 1;
window_set_size((res * window_m), (res * window_m));
camera_set_view_size(view_camera[0], res, res);
display_set_gui_size(res, res);
//surface_resize(application_surface, res, res);

event_inherited();
