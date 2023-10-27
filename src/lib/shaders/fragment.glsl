uniform vec2 resolution;
uniform float leftClamp;
uniform float rightClamp;
uniform vec2 position;
uniform float scale;
uniform float prec;

varying vec2 vUv;

// from https://gist.github.com/983/e170a24ae8eba2cd174f
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

int iter(float cx, float cy, int maxIter) {
  float x = 0.;
  float y = 0.;

  float xx = 0.;
  float yy = 0.;
  float xy = 0.;

  int i = maxIter;

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

  return maxIter - i;
}

void main() {
  float xmin = leftClamp / pow(1.5, scale) - position.x;
  float xmax = rightClamp / pow(1.5,scale) - position.x;

  float yRange = (xmax - xmin) * (16. / 10.);
  float ymin = -(yRange - position.y) / 3.6;
  float ymax = (yRange + position.y) / 3.6;

  float x = xmin + (xmax - xmin) * vUv.x;
  float y = ymin + (ymax - ymin) * vUv.y;

  int iterCount = 64 * int(prec);

  float i = float(iter(x, y, iterCount));
  float hue = 255. * (i / float(iterCount) / 20.);
  float val = (i > float(iterCount)) ? 0. : 1.;
  vec3 hsv = vec3(hue - 0.7, 1., val);
  vec3 color = hsv2rgb(hsv);

  gl_FragColor = vec4(color, 1.);
}
