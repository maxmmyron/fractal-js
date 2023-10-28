precision lowp float;
uniform vec2 position;
uniform float scale;

varying vec2 vUv;

// from https://gist.github.com/983/e170a24ae8eba2cd174f
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float iter(float cx, float cy, int maxIter) {
  float x = 0.;
  float y = 0.;

  float xx = 0.;
  float yy = 0.;
  float xy = 0.;

  int i = maxIter;

  // iterate while the point is within a circle of radius 2
  while ((i-- != 0) && (xx + yy < 4.)) {
    // calculate products
    xy = x * y;
    xx = x * x;
    yy = y * y;

    // x = x^2 - y^2 + cx
    x = xx - yy + cx;

    // y = 2xy + cy
    y = xy + xy + cy;
  }

  if (i < 1) {
    return 0.;
  }

  float logzn = log(xx + yy) / 2.;
  return float(i) + 1. - log(logzn / log(2.)) / log(2.);
}

void main() {
  float xmin = -2.4;
  float xmax = 1.0;

  // account for coordinate system on x-axis (-2.4 - 1.0)
  float center = xmin + (xmax - xmin) * 0.5;

  float xRange = (xmax - xmin);
  float yRange = xRange * (10. / 16.);

  float ymin = -(yRange) / 2.;
  float ymax = (yRange) / 2.;

  // given scale, calculate new xmin, xmax, ymin, ymax
  xmin = center - (xRange / 2.) / pow(1.5,scale) + position.x;
  xmax = center + (xRange / 2.) / pow(1.5,scale) + position.x;

  yRange = (xmax - xmin) * (10. / 16.);
  ymin = -(yRange) / 2. + position.y;
  ymax = (yRange) / 2. + position.y;

  float x = xmin + (xmax - xmin) * vUv.x;
  float y = ymin + (ymax - ymin) * vUv.y;

  int iterCount = 64 + int(pow(2., pow(scale, 0.66)));

  float smoothcol = iter(x, y, iterCount);

  if(smoothcol == 0.) {
    gl_FragColor = vec4(0.1, 0.1, 0.15, 1.0);
    return;
  }

  vec3 hsv = vec3(smoothcol / 500. - 0.5, 0.8, 0.75);
  vec3 color = hsv2rgb(hsv);

  gl_FragColor = vec4(color, 1.);
}
