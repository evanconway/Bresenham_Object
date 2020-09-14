
/// @desc Return radian value between 0 and 2pi for given vectors. Return -1 for 0, 0.
function angle_from_vecs(vec_x, vec_y) {
	
	if ((vec_x == 0) && (vec_y == 0)) {
		return -1;
	}
	
	var angle = 0;
	
	/* To make it easier to conceptualize angles relative to vectors, we
	reverse the y vector so that positive is up, and negative is down.*/
	vec_y *= -1;
	
	if (vec_x == 0) {
		if (vec_y > 0) {
			return pi/2;
		} else {
			return pi * 3/2;
		}
	} else if (vec_x > 0) {
		angle = arctan(vec_y / vec_x);
		if (angle < 0) {
			angle += 2 * pi;
		}
	} else {
		angle = arctan(vec_y / vec_x * -1);
		angle = pi - angle;
	}
	return angle;
}
