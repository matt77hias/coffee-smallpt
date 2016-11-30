M_PI = 3.14159265358979323846

clamp = (x, low, high) ->
  if x > high then high else if x < low then low else x

to_byte = (x, gamma) ->
  Math.trunc clamp(255.0 * x ** (1.0 / gamma), 0.0, 255.0)