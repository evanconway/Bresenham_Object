view_enabled = true;
view_visible[0] = true;
res = 100;
surface_resize(application_surface, res, res);
camera_set_view_size(view_camera[0], res, res);
window_m = 6;
window_set_size(res * window_m, res * window_m);
display_set_gui_size(res, res);
display_reset(0, true);

/*
We will attempt to explain, and implement, Bresenham's line algorithm. This equation ensures that there are no "corner" pixels when 
drawing a line. The equation works by iterating over each x position in the line, and determining the correct y value. It can be
modified to iterate over y values, choosing x values instead (for more vertical lines). To better understand this, let's first
flesh out some basic concepts of a line. Recall the equation for a linear line with no y offset: y = mx, where m is slope. Recall
also that the equation for slope is (y2 - y1) / (x2 - x1). Therefore, the equation for the y value in any linear line with a start 
and end point is: f(x) = (y2 - y1) / (x2 - x1) * x + y1. The y value resulting from this equation is not guaranteed to be an integer.
That is where Bresenham's line algorithm comes into play. It determines which y integer is best at a given x value. The normaly 
implementation accounts for the change of y to each x. However, we can simply determine the change each iteration, and round the y
value correctly. 
*/

function draw_bresen_line(x1, y1, x2, y2) {
	var dx = x2 - x1;
	var dy = y2 - y1;
	var m = undefined; // slope
	
	if (abs(dx) >= abs(dy)) {
		m = dy / dx;
		// determine whether to increment, or decrement x each pixel.
		if (x2 >= x1) {
			for (var _x = x1; _x <= x2; _x++) {
				var _y = y1 + m * (_x - x1);
				if (m >= 0) _y = floor(_y + 0.5);
				else _y = ceil(_y - 0.5);
				draw_rectangle(_x, _y, _x, _y, false); // use in favor of draw point to get correct pixel size
			}
		} else {
			for (var _x = x1; _x >= x2; _x--) {
				var _y = y1 + m * (_x - x1);
				if (m >= 0) _y = floor(_y + 0.5);
				else _y = ceil(_y - 0.5);
				draw_rectangle(_x, _y, _x, _y, false);
			}
		}
	} else {
		m = dx / dy;
		if (y2 >= y1) {
			for (var _y = y1; _y <= y2; _y++) {
				var _x = x1 + m * (_y - y1);
				if (m >= 0) _x = floor(_x + 0.5);
				else _x = ceil(_x - 0.5);
				draw_rectangle(_x, _y, _x, _y, false);
			}
		} else {
			for (var _y = y1; _y >= y2; _y--) {
				var _x = x1 + m * (_y - y1);
				if (m >= 0) _x = floor(_x + 0.5);
				else _x = ceil(_x - 0.5);
				draw_rectangle(_x, _y, _x, _y, false);
			}
		}
	}
}

start_x = 0; // starting position required for determining place on line path
start_y = 0;
travelled = 0; // this is the number of units along the beresenham path the object has travelled.
angle = 0; // in degrees
angle_prev = 0; // the value of angle in the previous update
velocity = 0;

function update() {
	
	// Reset distance travelled on path if the angle has changed.
	if (angle != angle_prev) {
		travelled = 0;
		start_x = x;
		start_y = y;
	}
	
	// convert angle to positive 
	var _angle = angle;
	if (_angle < 0) _angle += 360;
	var _angle_rad = _angle * pi / 180; // angle in radians
	var _velocity = 0;
	var _slope = 0;
	var _func_value = 0; // the input value for the bresenham function
	var _x = 0;
	var _y = 0;
	
	// logic is different for more horizontal paths vs vertical paths
	// horizontal
	if (_angle <= 45 ||_angle >= 315) || (_angle >= 135 && _angle <= 225) {
		
		// For horizontal angles, we iterate over the x values, and determine the y value.
		
		/* For a given velocity at a given angle, there is an x velocity and y velocity. That is
		to say, there is an amount along the x axis and y axis the object will move each update. 
		Since the bresenham algorithm determines the y value from the x, we need to find the correct
		x velocity to update our position. We find the x velocity here. */
		_velocity = cos(_angle_rad) * velocity;
		
		// For each unit along the path, the y value will increase by the slope.
		_slope = tan(_angle_rad);
		
		/* To determine x/y values, we need to determine how far into the bresenham path the object
		has travelled. Only whole numbers are recognized, and the value is made negative based on
		the angle. */
		travelled += _velocity;
		_func_value = floor(travelled);
		if (_angle >= 135 && _angle <= 225) {
			_func_value *= -1;
		} 
		
		// the x value is simply this change from the starting position
		x = start_x + _func_value;
		
		/* For each unit into the bresenham function, the y value changes by the slope. We round in a way
		that leans closer to the original start position because this is how the x values lean. */
		if (_slope >= 0) {
			y = floor(start_y + _slope * _func_value + 0.5);
		} else {
			y = ceil(start_y + _slope * _func_value - 0.5);
		}
	} else {
		
		/* Same logic above, but for vertical paths. In this case, we iterate over the y values of the line, 
		and determine the x values. Velocity here is now the y component, and the slope is the change to 
		the x value for each unit along the y axis. */
		_velocity = sin(_angle_rad) * velocity;
		_slope = 1 / tan(_angle_rad);
		travelled += _velocity;
		_func_value = floor(travelled);
		if (_angle > 45 && _angle < 135) {
			_func_value *= -1;
		} 
		y = start_y + _func_value;
		if (_slope >= 0) {
			x = floor(start_x + _slope * _func_value + 0.5);
		} else {
			x = ceil(start_x + _slope * _func_value - 0.5);
		}
	}
	angle_prev = angle;
}