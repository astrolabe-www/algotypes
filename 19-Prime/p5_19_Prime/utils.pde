void drawInputFrames(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);

  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME[2]));

  for (int i = 0; i < in.length; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(in[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(in[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  int[] ps = Primal.primes(INPUT_FRAMES);

  randomSeed(1);

  mpg.beginDraw();
  mpg.fill(255, 0, 0, 20);
  mpg.noStroke();
  mpg.rectMode(CENTER);

  float M = OUT_SCALE * 4;
  PVector m = new PVector(M, M * mpg.height / mpg.width);
  PVector xy;

  mpg.pushMatrix();
  mpg.translate(mpg.width / 2, mpg.height / 2);

  for (int i = 1; i < ps.length; i++) {
    xy = getXY(ps[i]);
    mpg.rect(m.x * xy.x, m.y * xy.y, m.x, m.x);
    xy = getXY(Primal.nextPrime(int(random(min(ps[i-1], ps[i]), max(ps[i-1], ps[i])))));
    mpg.ellipse(m.x * xy.x, m.y * xy.y, m.x, m.x);
  }
  mpg.popMatrix();
  mpg.endDraw();
}

void drawBorders(PGraphics mpg, int bwidth) {
  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.stroke(255);
  mpg.fill(255);
  mpg.rect(0, 0, mpg.width, bwidth);
  mpg.rect(0, mpg.height - bwidth, mpg.width, bwidth);
  mpg.rect(0, 0, bwidth, mpg.height);
  mpg.rect(mpg.width - bwidth, 0, bwidth, mpg.height);

  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(1);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.endDraw();
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
