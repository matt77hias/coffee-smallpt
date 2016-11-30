# Scene
REFRACTIVE_INDEX_OUT = 1.0
REFRACTIVE_INDEX_IN = 1.5
spheres = [
  new Sphere(1e5, new Vector3(1e5 + 1, 40.8, 81.6), new Vector3(0.0, 0.0, 0.0), new Vector3(0.75, 0.25, 0.25), DIFFUSE)
  new Sphere(1e5, new Vector3(-1e5 + 99, 40.8, 81.6), new Vector3(0.0, 0.0, 0.0), new Vector3(0.25, 0.25, 0.75), DIFFUSE)
  new Sphere(1e5, new Vector3(50, 40.8, 1e5), new Vector3(0.0, 0.0, 0.0), new Vector3(0.75, 0.75, 0.75), DIFFUSE)
  new Sphere(1e5, new Vector3(50, 40.8, -1e5 + 170), new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 0.0, 0.0), DIFFUSE)
  new Sphere(1e5, new Vector3(50, 1e5, 81.6), new Vector3(0.0, 0.0, 0.0), new Vector3(0.75, 0.75, 0.75), DIFFUSE)
  new Sphere(1e5, new Vector3(50, -1e5 + 81.6, 81.6), new Vector3(0.0, 0.0, 0.0), new Vector3(0.75, 0.75, 0.75), DIFFUSE)
  new Sphere(16.5, new Vector3(27, 16.5, 47), new Vector3(0.0, 0.0, 0.0), new Vector3(0.999, 0.999, 0.999), SPECULAR)
  new Sphere(16.5, new Vector3(73, 16.5, 78), new Vector3(0.0, 0.0, 0.0), new Vector3(0.999, 0.999, 0.999), REFRACTIVE)
  new Sphere(600, new Vector3(50, 681.6 - .27, 81.6), new Vector3(12.0, 12.0, 12.0), new Vector3(0.0, 0.0, 0.0), DIFFUSE)
]

intersect_scene = (ray) ->
  id = 0
  hit = false
  i = 0
  while i < spheres.length
    if spheres[i].intersect(ray)
      hit = true
      id = i
    ++i
  [
    hit
    id
  ]

# Radiance

radiance = (ray) ->
  r = ray
  L = new Vector3(0.0, 0.0, 0.0)
  F = new Vector3(1.0, 1.0, 1.0)
  loop
    hit_record = intersect_scene(r)
    hit = hit_record[0]
    if !hit
      return L
    id = hit_record[1]
    shape = spheres[id]
    p = r.eval(r.tmax)
    n = Vector3.sub(p, shape.p).normalize()
    L = Vector3.add(L, Vector3.mul(F, shape.e))
    F = Vector3.mul(F, shape.f)
    # Russian roulette
    if r.depth > 4
      continue_probability = shape.f.max_value()
      if uniform_float() >= continue_probability
        return L
      F = Vector3.div(F, continue_probability)
    # Next path segment
    switch shape.reflection_t
      when SPECULAR
        dRe = ideal_specular_reflect(r.d, n)
        r = new Ray(p, dRe, EPSILON_SPHERE, Infinity, r.depth + 1)
        continue
      when REFRACTIVE
        refraction_record = ideal_specular_transmit(r.d, n, REFRACTIVE_INDEX_OUT, REFRACTIVE_INDEX_IN)
        dTr = refraction_record[0]
        pr = refraction_record[1]
        F = Vector3.mul(F, pr)
        r = new Ray(p, dTr, EPSILON_SPHERE, Infinity, r.depth + 1)
        continue
      else
        w = if Vector3.dot(n, r.d) < 0 then n else Vector3.minus(n)
        u = Vector3.cross((if Math.abs(w.x) > 0.1 then new Vector3(0.0, 1.0, 0.0) else new Vector3(1.0, 0.0, 0.0)), w).normalize()
        v = Vector3.cross(w, u)
        sample_d = cosine_weighted_sample_on_hemisphere(uniform_float(), uniform_float())
        d = Vector3.add(Vector3.add(Vector3.mul(sample_d.x, u), Vector3.mul(sample_d.y, v)), Vector3.mul(sample_d.z, w)).normalize()
        r = new Ray(p, d, EPSILON_SPHERE, Infinity, r.depth + 1)
        continue
  return

# Main

main = ->
  t0 = performance.now()
  nb_samples = 64 / 4
  w = 1024
  h = 768
  eye = new Vector3(50, 52, 295.6)
  gaze = new Vector3(0, -0.042612, -1).normalize()
  fov = 0.5135
  cx = new Vector3(w * fov / h, 0.0, 0.0)
  cy = Vector3.mul(Vector3.cross(cx, gaze).normalize(), fov)
  Ls = []
  j = 0
  while j < w * h
    Ls.push new Vector3(0.0, 0.0, 0.0)
    ++j
  y = 0
  while y < h
    # pixel row
    console.log '\u000dRendering (' + nb_samples * 4 + ' spp) ' + (100.0 * y / (h - 1)).toFixed(2) + '%'
    x = 0
    while x < w
      # pixel column
      sy = 0
      while sy < 2
        i = (h - 1 - y) * w + x
        # 2 subpixel row
        sx = 0
        while sx < 2
          # 2 subpixel column
          L = new Vector3(0.0, 0.0, 0.0)
          s = 0
          while s < nb_samples
            #  samples per subpixel
            u1 = 2.0 * uniform_float()
            u2 = 2.0 * uniform_float()
            dx = if u1 < 1 then Math.sqrt(u1) - 1.0 else 1.0 - Math.sqrt(2.0 - u1)
            dy = if u2 < 1 then Math.sqrt(u2) - 1.0 else 1.0 - Math.sqrt(2.0 - u2)
            d = Vector3.add(Vector3.add(Vector3.mul(cx, ((sx + 0.5 + dx) / 2.0 + x) / w - 0.5), Vector3.mul(cy, ((sy + 0.5 + dy) / 2.0 + y) / h - 0.5)), gaze)
            L = Vector3.add(L, Vector3.mul(radiance(new Ray(Vector3.add(eye, Vector3.mul(d, 130)), d.normalize(), EPSILON_SPHERE, Infinity, 0)), 1.0 / nb_samples))
            ++s
          Ls[i] = Vector3.add(Ls[i], Vector3.mul(0.25, Vector3.clamp(L, 0.0, 1.0)))
          ++sx
        ++sy
      ++x
    ++y
  write_ppm w, h, Ls
  t1 = performance.now()
  console.log 'Rendering time: ' + t1 - t0 + ' ms'
  display w, h, Ls
  return