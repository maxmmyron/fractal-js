precision lowp float;

uniform vec2 resolution;
uniform vec2 mn;
uniform vec2 mx;
uniform float scale;

// the exponent that z is raised to (mandelbrot specific)
uniform int mexp;

// the constant c in the julia set
uniform vec2 juliaC;

// the view to render:
// 0: mandelbrot
// 1: julia
// 2: burning ship
uniform int view;

varying vec2 vUv;

// from https://gist.github.com/983/e170a24ae8eba2cd174f
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float julia(vec2 c, vec2 p, int maxIter) {
  float x = p.x;
  float y = p.y;

  float xx = x * x;
  float yy = y * y;
  float xy = x * y;

  int i = maxIter;

  // iterate while the point is within a circle of radius 2
  while ((i-- != 0) && (xx + yy < 4.)) {
    // calculate products
    xy = x * y;
    xx = x * x;
    yy = y * y;

    // x = x^2 - y^2 + cx
    x = xx - yy + c.x;

    // y = 2xy + cy
    y = xy + xy + c.y;
  }

  if (i < 1) {
    return 0.;
  }

  float logzn = log(xx + yy) / 2.;
  return float(i) + 1. - log(logzn / log(2.)) / log(2.);
}

vec2 mbrot2(vec2 z, vec2 c) {
  // z.x = x^2 - y^2 + cx (real part)
  float temp = z.x * z.x - z.y * z.y + c.x;
  // z.y = 2xy + cy (imaginary part)
  return(vec2(temp, 2. * z.x * z.y + c.y));
}

vec2 mbrot3(vec2 z, vec2 c) {
  // z.x = x^3 - 3xy^2 + cx (real part)
  float temp = z.x * z.x * z.x - 3. * z.x * z.y * z.y + c.x;
  // z.y = 3x^2y - y^3 + cy (imaginary part)
  return(vec2(temp, 3. * z.x * z.x * z.y - z.y * z.y * z.y + c.y));
}

vec2 mbrot4(vec2 z, vec2 c) {
  // z.x = x^4 - 6x^2y^2 + y^4 + cx (real part)
  float temp = z.x * z.x * z.x * z.x - 6. * z.x * z.x * z.y * z.y + z.y * z.y * z.y * z.y + c.x;
  // z.y = 4x^3y - 4xy^3 + cy (imaginary part)
  return(vec2(temp, 4. * z.x * z.x * z.x * z.y - 4. * z.x * z.y * z.y * z.y + c.y));
}

// a general function for a multibrot of degree n. we restrict this to n>4 because
// it's pretty expensive to compute atan
vec2 mbrotn(vec2 z, vec2 c, int n) {
  float temp = pow((z.x * z.x + z.y * z.y), float(n) / 2.) * cos(float(n) * atan(z.y, z.x)) + c.x;
  return(vec2(temp, pow((z.x * z.x + z.y * z.y), float(n) / 2.) * sin(float(n) * atan(z.y, z.x)) + c.y));
}

float brot(vec2 c, int maxIter) {
  vec2 z = vec2(0., 0.);

  float x = 0.;
  float y = 0.;

  int i = maxIter;

  // iterate while the point is within a circle of radius 2
  while ((i-- != 0) && ((z.x * z.x) + (z.y * z.y) < 4.)) {
    switch(mexp) {
      case 2:
        z = mbrot2(z, c);
        break;
      case 3:
        z = mbrot3(z, c);
        break;
      case 4:
        z = mbrot4(z, c);
        break;
      default:
        z = mbrotn(z, c, mexp);
    }
  }

  if (i < 1) {
    return 0.;
  }

  float logzn = log((z.x * z.x) + (z.y * z.y)) / 2.;
  return float(i) + 1. - log(logzn / log(2.)) / log(2.);
}

float bship(vec2 c, int maxIter) {
  vec2 z = vec2(0., 0.);

  float xx = 0.;
  float yy = 0.;
  float xy = 0.;

  int i = maxIter;

  // iterate while the point is within a circle of radius 2
  while ((i-- != 0) && (xx + yy < 4.)) {
    z = vec2(abs(z.x), abs(z.y));
    // calculate products
    xy = z.x * z.y;
    xx = z.x * z.x;
    yy = z.y * z.y;

    z = vec2(xx - yy + c.x, xy + xy + c.y);
  }

  if (i < 1) {
    return 0.;
  }

  float logzn = log(xx + yy) / 2.;
  return float(i) + 1. - log(logzn / log(2.)) / log(2.);


}

void main() {
  float x = mn.x + (mx.x - mn.x) * vUv.x;
  float y = mn.y + (mx.y - mn.y) * vUv.y;

  int iterCount = 256 + int(pow(scale, 2.));

  float smoothcol;
  switch (view) {
    case 0:
      smoothcol = brot(vec2(x,y), iterCount);
      break;
    case 1:
      smoothcol = julia(juliaC, vec2(x, y), iterCount);
      break;
    case 2:
      // TODO: is Y flipped?
      smoothcol = bship(vec2(x, -y), iterCount);
  }

  if(smoothcol == 0.) {
    gl_FragColor = vec4(0.1, 0.1, 0.15, 1.0);
    return;
  }

  // TODO: HSV is used because it lets us generate a cyclic color map lazily.
  // switch to custom color maps for nicer gradients
  vec3 hsv = vec3(smoothcol / 400., 0.7, 0.5);
  vec3 color = hsv2rgb(hsv);

  gl_FragColor = vec4(color, 1.);
}
