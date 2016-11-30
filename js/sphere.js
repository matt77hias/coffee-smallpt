// Generated by CoffeeScript 1.11.1
var DIFFUSE, EPSILON_SPHERE, REFRACTIVE, SPECULAR, Sphere;

DIFFUSE = 0;

SPECULAR = 1;

REFRACTIVE = 2;

Sphere = function(r, p, e, f, reflection_t) {
  this.r = r;
  this.p = p.copy();
  this.e = e.copy();
  this.f = f.copy();
  this.reflection_t = reflection_t;
};

EPSILON_SPHERE = 1.0e-4;

Sphere.prototype = {
  constructor: Sphere,
  intersect: function(ray) {
    var D, dop, op, sqrtD, tmax, tmin;
    op = Vector3.sub(this.p, ray.o);
    dop = Vector3.dot(ray.d, op);
    D = dop * dop - Vector3.dot(op, op) + this.r * this.r;
    if (D < 0) {
      return false;
    }
    sqrtD = Math.sqrt(D);
    tmin = dop - sqrtD;
    if (ray.tmin < tmin && tmin < ray.tmax) {
      ray.tmax = tmin;
      return true;
    }
    tmax = dop + sqrtD;
    if (ray.tmin < tmax && tmax < ray.tmax) {
      ray.tmax = tmax;
      return true;
    }
    return false;
  }
};
