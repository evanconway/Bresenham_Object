
start_x = 0; // starting position required for determining place on line path
start_y = 0;
travelled = 0; // this is the number of units along the beresenham path the object has travelled.
angle = 0; // in degrees
angle_prev = 0; // the value of angle in the previous update
velocity = 0;



function update_bresenham_line() {
	
	// Reset distance travelled on path if the angle has changed.
	if ((angle != angle_prev) || (velocity <= 0)) {
		if (velocity == 0) {
			travelled = 0;
		}
		while (travelled >= 1) {
			travelled -= 1;
		}
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
	var _x;
	var _y;
	
	// logic is different for more horizontal paths vs vertical paths
	// horizontal
	if (_angle <= 45 || _angle >= 315) || (_angle >= 135 && _angle <= 225) {
		
		// For horizontal angles, we iterate over the x values, and determine the y value.
		
		/* For a given velocity at a given angle, there is an x velocity and y velocity. That is
		to say, there is an amount along the x axis and y axis the object will move each update. 
		Since the bresenham algorithm determines the y value from the x, we need to find the correct
		x velocity to update our position. We find the x velocity here. */
		_velocity = abs(cos(_angle_rad)) * velocity;
		
		// For each unit along the path, the y value will increase by the slope.
		_slope = tan(_angle_rad);
		
		/* To determine x/y values, we need to determine how far into the bresenham path the object
		has travelled. Only whole numbers are recognized, and the value is made negative based on
		the angle. */
		travelled += _velocity;
		_func_value = floor(travelled);
		
		// the x value is simply this change from the starting position
		if (_angle <= 45 || _angle >= 315) {
			_x = start_x + _func_value;
			_slope *= -1;
		} else {
			_x = start_x - _func_value;
		}
		
		/* For each unit into the bresenham function, the y value changes by the slope. We round in a way
		that leans closer to the original start position because this is how the x values lean. */
		if (_slope >= 0) {
			_y = floor(start_y + _slope * _func_value + 0.5);
		} else {
			_y = ceil(start_y + _slope * _func_value - 0.5);
		}
	} else {
		
		/* Same logic above, but for vertical paths. In this case, we iterate over the y values of the line, 
		and determine the x values. Velocity here is now the y component, and the slope is the change to 
		the x value for each unit along the y axis. */
		_velocity = abs(sin(_angle_rad)) * velocity;
		
		/* We encountered a frustrating bug where the sine function returns a number just short of 1 when the angle 
		is 90 or 270 degrees. So we round it just a bit to ensure a proper "1" just for those edge cases. */
		_velocity *= 1000;
		_velocity = floor(_velocity + 0.5);
		_velocity /= 1000;
		
		_slope = 1 / tan(_angle_rad);
		travelled += _velocity;
		_func_value = floor(travelled);
		
		if (_angle > 225 && _angle < 315) {
			_y = start_y + _func_value;
			_slope *= -1;
		} else {
			_y = start_y - _func_value;
		}

		if (_slope >= 0) {
			_x = floor(start_x + _slope * _func_value + 0.5);
		} else {
			_x = ceil(start_x + _slope * _func_value - 0.5);
		}
	}
	angle_prev = angle;
	
	// To return the change in x/y position, we subract the old position from the new.
	_x -= x;
	_y -= y;
	return { change_x: _x, change_y: _y };
}