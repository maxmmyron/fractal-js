uniform vec2 resolution;
uniform float leftClamp;
uniform float rightClamp;
uniform vec2 position;
uniform float scale;

varying vec2 vUv;

int iter(float cx, float cy, int maxIter) {
  float x = 0.;
  float y = 0.;

  float xx = x * x;
  float yy = y * y;
  float xy = x * y;

  int i = maxIter;

  while ((i-- != 0) && (xx + yy < 10.)) {
    xy = x * y;
    xx = x * x;
    yy = y * y;
    x = xx - yy + cx;
    y = xy + xy + cy;
  }

  return maxIter - i;
}

void main() {
  float xmin = (leftClamp - position.x) / scale;
  float xmax = (rightClamp - position.x) / scale;

  float yRange = (xmax - xmin) * (16. / 10.);
  float ymin = -(yRange - position.y) / 3.4;
  float ymax = (yRange + position.y) / 3.4;

  float x = xmin + (xmax - xmin) * vUv.x;
  float y = ymin + (ymax - ymin) * vUv.y;

  const int iterCount = 40;

  float i = float(iter(x, y, iterCount));
  float c = i / float(iterCount);
  vec3 color = vec3(1.-c);

  gl_FragColor = vec4(color, 1.);
}
