void drawOutput(PGraphics mpg) {
  randomSeed(1);

  mpg.beginDraw();
  mpg.fill(255, 0, 0, 20);
  mpg.noStroke();
  mpg.rectMode(CENTER);

  float M = (OUTPUT != Output.TELEGRAM) ? OUT_SCALE * 4 : OUT_SCALE * 6.66;
  PVector m = new PVector(M, M * mpg.height / mpg.width);
  PVector xy;

  mpg.pushMatrix();
  mpg.translate(mpg.width / 2, mpg.height / 2);

  for (int i = 1; i < mPrimes.length; i++) {
    xy = getXY(mPrimes[i]);
    mpg.rect(m.x * xy.x, m.y * xy.y, m.x, m.x);
    xy = getXY(Primal.nextPrime(int(random(min(mPrimes[i-1], mPrimes[i]), max(mPrimes[i-1], mPrimes[i])))));
    mpg.ellipse(m.x * xy.x, m.y * xy.y, m.x, m.x);
  }
  mpg.popMatrix();
  mpg.endDraw();
}

void saveOutput(String filename) {
  byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME[2]));
  byte[] out = new byte[in.length];
  for (int i = 0; i < out.length / 2; i += 1) {
    out[2 * i + 0] = (byte)((mPrimes[i] << 8) & 0xff);
    out[2 * i + 1] = (byte)((mPrimes[i] << 0) & 0xff);
  }
  saveBytes(filename, out);
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
