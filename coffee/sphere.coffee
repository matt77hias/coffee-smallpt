DIFFUSE = 0
SPECULAR = 1
REFRACTIVE = 2

Sphere = (r, p, e, f, reflection_t) ->
  @r = r
  @p = p.copy()
  @e = e.copy()
  @f = f.copy()
  @reflection_t = reflection_t
  return

EPSILON_SPHERE = 1.0e-4
Sphere.prototype =
  constructor: Sphere
  intersect: (ray) ->
    op = Vector3.sub(@p, ray.o)
    dop = Vector3.dot(ray.d, op)
    D = dop * dop - Vector3.dot(op, op) + @r * @r
    if D < 0
      return false
    sqrtD = Math.sqrt(D)
    tmin = dop - sqrtD
    if ray.tmin < tmin and tmin < ray.tmax
      ray.tmax = tmin
      return true
    tmax = dop + sqrtD
    if ray.tmin < tmax and tmax < ray.tmax
      ray.tmax = tmax
      return true
    false