// Generated by CoffeeScript 1.11.1
var M_PI, clamp, to_byte;

M_PI = 3.14159265358979323846;

clamp = function(x, low, high) {
  if (x > high) {
    return high;
  } else if (x < low) {
    return low;
  } else {
    return x;
  }
};

to_byte = function(x, gamma) {
  return Math.trunc(clamp(255.0 * Math.pow(x, 1.0 / gamma), 0.0, 255.0));
};
