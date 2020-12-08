import java.util.Arrays;

static final boolean OUT_HORIZONTAL = true;
static final boolean OUT_VERTICAL = false;
static final boolean OUT_FILL = true;
static final boolean OUT_SORT = true;

void drawOutput(PGraphics mpg) {
  int maxNonce = 0;
  int minNonce = 0x7fffffff;
  int[] nonces = new int[chain.length];

  for (int i = 0; i < chain.length; i++) {
    if (chain[i].nonce() > maxNonce) maxNonce = chain[i].nonce();
    if (chain[i].nonce() < minNonce) minNonce = chain[i].nonce();
    nonces[i] = chain[i].nonce();
  }

  if (OUT_SORT) Arrays.sort(nonces);

  mpg.beginDraw();
  mpg.noFill();
  mpg.stroke(200, 0, 0, 132);
  mpg.strokeWeight(1.2 * OUT_SCALE);
  if (OUT_FILL) mpg.fill(200, 0, 0, 16);
  mpg.endDraw();

  if (OUT_VERTICAL) drawOutputV(mpg, nonces, minNonce, maxNonce);
  if (OUT_HORIZONTAL) drawOutputH(mpg, nonces, minNonce, maxNonce);
}

void drawOutputV(PGraphics mpg, int[] nonces, int minNonce, int maxNonce) {
  noiseSeed(101010);

  mpg.beginDraw();
  for (int i = nonces.length - 1; i >= 0; i--) {
    float noiseScale = map(max(nonces[i], 10e3), 0, maxNonce, 2048, 256) * OUT_SCALE / 10.0;
    float xScale = map(max(nonces[i], 10e3), minNonce, maxNonce, 1.0, 0.8);
    float xc = (i + 0.5) * mpg.width / nonces.length;

    mpg.beginShape();
    mpg.vertex(xc, -1);
    for (int y = 0; y < mpg.height; y++) {
      float x = xc + (2 * xScale * noise(y/noiseScale, xc/noiseScale) - xScale) * mpg.width / chain.length;
      mpg.vertex(x, y);
    }
    mpg.vertex(xc, mpg.height);
    mpg.endShape();
  }
  mpg.endDraw();
}

void drawOutputH(PGraphics mpg, int[] nonces, int minNonce, int maxNonce) {
  noiseSeed(101010);

  mpg.beginDraw();
  for (int i = nonces.length - 1; i >= 0; i--) {
    float noiseScale = map(max(nonces[i], 10e3), 0, maxNonce, 2048, 256) * OUT_SCALE / 10.0;
    float yScale = map(max(nonces[i], 10e3), minNonce, maxNonce, 1.0, 0.8);
    float yc = (i + 0.5) * mpg.height / nonces.length;

    mpg.beginShape();
    mpg.vertex(-1, yc);
    for (int x = 0; x < mpg.width; x++) {
      float y = yc + (2 * yScale * noise(x/noiseScale, yc/noiseScale) - yScale) * mpg.height / chain.length;
      mpg.vertex(x, y);
    }
    mpg.vertex(mpg.width, yc);
    mpg.endShape();
  }
  mpg.endDraw();
}
