/// @description Insert description here
// You can write your code in this editor

value += step;

draw_text(10, 10, "Value: " + string(value));
draw_text(10, 26, "Floor + 0.5: " + string(floor(value + 0.5)));
draw_text(10, 42, "Ceil - 0.5: " + string(ceil(value - 0.5)));
