precision lowp float;

uniform vec2 resolution;
uniform vec2 mn;
uniform vec2 mx;
uniform float scale;

uniform vec2 juliaC;
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

float brot(vec2 c, int maxIter) {
  vec2 z = vec2(0., 0.);

  float x = 0.;
  float y = 0.;

  float xx = 0.;
  float yy = 0.;
  float xy = 0.;

  int i = maxIter;

  // iterate while the point is within a circle of radius 2
  while ((i-- != 0) && (xx + yy < 4.)) {
    // calculate products
    xy = z.x * z.y;
    xx = z.x * z.x;
    yy = z.y * z.y;

    // z = z^2 + c
    z = vec2(xx - yy + c.x, xy + xy + c.y);

  }

  if (i < 1) {
    return 0.;
  }

  float logzn = log(xx + yy) / 2.;
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

  vec3 hsv = vec3(smoothcol / 100. - 0.5, 0.8, 0.75);
  vec3 color = hsv2rgb(hsv);

  gl_FragColor = vec4(color, 1.);
}
