uniform_sample_on_hemisphere = (u1, u2) ->
  sin_theta = Math.sqrt(Math.max(0.0, 1.0 - (u1 * u1)))
  phi = 2.0 * M_PI * u2
  new Vector3(Math.cos(phi) * sin_theta, Math.sin(phi) * sin_theta, u1)

cosine_weighted_sample_on_hemisphere = (u1, u2) ->
  cos_theta = Math.sqrt(1.0 - u1)
  sin_theta = Math.sqrt(u1)
  phi = 2.0 * M_PI * u2
  new Vector3(Math.cos(phi) * sin_theta, Math.sin(phi) * sin_theta, cos_theta)