Ray = (o, d, tmin, tmax, depth) ->
  @o = o.copy()
  @d = d.copy()
  @tmin = tmin
  @tmax = tmax
  @depth = depth
  return

Ray.prototype =
  constructor: Ray
  eval: (t) ->
    Vector3.add @o, Vector3.mul(@d, t)