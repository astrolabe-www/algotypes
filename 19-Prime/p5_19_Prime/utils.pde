int OVER_SAMPLE = 1;

void drawInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME[2]));
  PGraphics mpg = createGraphics(OVER_SAMPLE * width, OVER_SAMPLE * height);

  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.smooth();
  mpg.stroke(0, 32);
  mpg.strokeWeight(0.9 * OVER_SAMPLE);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);

  for (int i = 0; i < in.length; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(in[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(in[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();

  pushMatrix();
  scale(1.0 / OVER_SAMPLE);
  image(mpg, 0, 0);
  popMatrix();
}

void drawOutput(int[] ps) {
  randomSeed(1);
  fill(255, 0, 0, 20);
  noStroke();
  rectMode(CENTER);

  float M = 4;
  PVector m = new PVector(M, M * height / width);
  PVector xy;

  pushMatrix();
  translate(width / 2, height / 2);

  for (int i = 1; i < ps.length; i++) {
    xy = getXY(ps[i]);
    rect(m.x * xy.x, m.y * xy.y, m.x, m.x);
    xy = getXY(Primal.nextPrime(int(random(min(ps[i-1], ps[i]), max(ps[i-1], ps[i])))));
    ellipse(m.x * xy.x, m.y * xy.y, m.x, m.x);
  }
  popMatrix();
}

public PVector getXY(int n) {
  if (n == 0) return new PVector(0, 0);
  int w = int(sqrt(n)) + 1;
  int n0 = (w - 1) * (w - 1);
  int n1 = w * w - w;
  PVector xy0 = (w % 2 == 0) ? new PVector(w / 2, w / 2 - 1) : new PVector((1 - w) / 2, (1 - w) / 2);

  int dx = n * ((n1 - 1) / n) - (n % n1);
  int dy = (w - 1) * (n / n1) + (n % n0) * (1 - (n / n1));

  dx *= (w % 2 == 0) ? 1 : -1;
  dy *= (w % 2 == 0) ? -1 : 1;

  return new PVector(xy0.x + dx, xy0.y + dy);
}

void drawBorders(int bwidth) {
  rectMode(CORNER);
  stroke(255);
  fill(255);
  rect(0, 0, width, bwidth);
  rect(0, height-bwidth, width, bwidth);
  rect(0, 0, bwidth, height);
  rect(width-bwidth, 0, bwidth, height);

  noFill();
  stroke(10);
  rect(1, 1, width-3, height-3);
}
