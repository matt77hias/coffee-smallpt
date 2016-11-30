reflectance0 = (n1, n2) ->
  sqrt_R0 = (n1 - n2) / (n1 + n2)
  sqrt_R0 * sqrt_R0

schlick_reflectance = (n1, n2, c) ->
  R0 = reflectance0(n1, n2)
  R0 + (1 - R0) * c * c * c * c * c

ideal_specular_reflect = (d, n) ->
  Vector3.sub d, Vector3.mul(2.0 * Vector3.dot(n, d), n)

ideal_specular_transmit = (d, n, n_out, n_in) ->
  d_Re = ideal_specular_reflect(d, n)
  out_to_in = Vector3.dot(n, d) < 0
  nl = if out_to_in then n else Vector3.minus(n)
  nn = if out_to_in then n_out / n_in else n_in / n_out
  cos_theta = Vector3.dot(d, nl)
  cos2_phi = 1.0 - (nn * nn * (1.0 - (cos_theta * cos_theta)))
  # Total Internal Reflection
  if cos2_phi < 0
    return [
      d_Re
      1.0
    ]
  d_Tr = Vector3.sub(Vector3.mul(nn, d), Vector3.mul(nl, nn * cos_theta + Math.sqrt(cos2_phi))).normalize()
  c = 1.0 - (if out_to_in then -cos_theta else Vector3.dot(d_Tr, n))
  Re = schlick_reflectance(n_out, n_in, c)
  p_Re = 0.25 + 0.5 * Re
  if uniform_float() < p_Re
    [
      d_Re
      Re / p_Re
    ]
  else
    Tr = 1.0 - Re
    p_Tr = 1.0 - p_Re
    [
      d_Tr
      Tr / p_Tr
    ]