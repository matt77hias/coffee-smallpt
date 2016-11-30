Vector3 = (x, y, z) ->
  @x = x
  @y = y
  @z = z
  return

Vector3.prototype =
  constructor: Vector3
  copy: ->
    new Vector3(@x, @y, @z)
  set: (x, y, z) ->
    @x = x
    @y = y
    @z = z
    return
  get: (index) ->
    switch index
      when 0
        return @x
      when 1
        return @y
      else
        return @z
    return
  getX: ->
    @x
  getY: ->
    @y
  getZ: ->
    @z
  min_dimension: ->
    if @x < @y and @x < @z then 0 else if @y < @z then 1 else 2
  max_dimension: ->
    if @x > @y and @x > @z then 0 else if @y > @z then 1 else 2
  min_value: ->
    if @x < @y and @x < @z then @x else if @y < @z then @y else @z
  max_value: ->
    if @x > @y and @x > @z then @x else if @y > @z then @y else @z
  norm2_squared: ->
    @x * @x + @y * @y + @z * @z
  norm2: ->
    Math.sqrt @norm2_squared()
  normalize: ->
    a = 1.0 / @norm2()
    @x *= a
    @y *= a
    @z *= a
    this

Vector3.minus = (v) ->
  new Vector3(-v.x, -v.y, -v.z)

Vector3.add = (v1, v2) ->
  if v1 instanceof Vector3 then (if v2 instanceof Vector3 then new Vector3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z) else new Vector3(v1.x + v2, v1.y + v2, v1.z + v2)) else if v2 instanceof Vector3 then new Vector3(v1 + v2.x, v1 + v2.y, v1 + v2.z) else v1 + v2

Vector3.sub = (v1, v2) ->
  if v1 instanceof Vector3 then (if v2 instanceof Vector3 then new Vector3(v1.x - (v2.x), v1.y - (v2.y), v1.z - (v2.z)) else new Vector3(v1.x - v2, v1.y - v2, v1.z - v2)) else if v2 instanceof Vector3 then new Vector3(v1 - (v2.x), v1 - (v2.y), v1 - (v2.z)) else v1 - v2

Vector3.mul = (v1, v2) ->
  if v1 instanceof Vector3 then (if v2 instanceof Vector3 then new Vector3(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z) else new Vector3(v1.x * v2, v1.y * v2, v1.z * v2)) else if v2 instanceof Vector3 then new Vector3(v1 * v2.x, v1 * v2.y, v1 * v2.z) else v1 * v2

Vector3.div = (v1, v2) ->
  if v1 instanceof Vector3 then (if v2 instanceof Vector3 then new Vector3(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z) else new Vector3(v1.x / v2, v1.y / v2, v1.z / v2)) else if v2 instanceof Vector3 then new Vector3(v1 / v2.x, v1 / v2.y, v1 / v2.z) else v1 / v2

Vector3.dot = (v1, v2) ->
  v1.x * v2.x + v1.y * v2.y + v1.z * v2.z

Vector3.cross = (v1, v2) ->
  new Vector3(v1.y * v2.z - (v1.z * v2.y), v1.z * v2.x - (v1.x * v2.z), v1.x * v2.y - (v1.y * v2.x))

Vector3.eq = (v1, v2) ->
  v1.x == v2.x and v1.y == v2.y and v1.z == v2.z

Vector3.ne = (v1, v2) ->
  v1.x != v2.x or v1.y != v2.y or v1.z != v2.z

Vector3.lt = (v1, v2) ->
  v1.x < v2.x and v1.y < v2.y and v1.z < v2.z

Vector3.le = (v1, v2) ->
  v1.x <= v2.x and v1.y <= v2.y and v1.z <= v2.z

Vector3.gt = (v1, v2) ->
  v1.x > v2.x and v1.y > v2.y and v1.z > v2.z

Vector3.ge = (v1, v2) ->
  v1.x >= v2.x and v1.y >= v2.y and v1.z >= v2.z

Vector3.apply_unary = (f, v) ->
  new Vector3(f(v.x), f(v.y), f(v.z))

Vector3.apply_binary = (f, v1, v2) ->
  new Vector3(f(v1.x, v2.x), f(v1.y, v2.y), f(v1.z, v2.z))

Vector3.sqrt = (v) ->
  Vector3.apply_unary Math.sqrt, v

Vector3.pow = (v, e) ->

  fixed_pow = (a) ->
    a ** e

  Vector3.apply_unary fixed_pow, v

Vector3.abs = (v) ->
  Vector3.apply_unary Math.abs, v

Vector3.min = (v1, v2) ->
  Vector3.apply_binary Math.min, v1, v2

Vector3.max = (v1, v2) ->
  Vector3.apply_binary Math.max, v1, v2

Vector3.round = (v) ->
  Vector3.apply_unary Math.round, v

Vector3.ceil = (v) ->
  Vector3.apply_unary Math.ceil, v

Vector3.floor = (v) ->
  Vector3.apply_unary Math.floor, v

Vector3.trunc = (v) ->
  Vector3.apply_unary Math.trunc, v

Vector3.clamp = (v, low, high) ->

  fixed_clamp = (a) ->
    clamp a, low, high

  Vector3.apply_unary fixed_clamp, v

Vector3.lerp = (a, v1, v2) ->
  Vector3.add v1, Vector3.mul(a, Vector3.sub(v2, v1))

Vector3.permute = (v, x, y, z) ->
  new Vector3(v.get(x), v.get(y), v.get(z))