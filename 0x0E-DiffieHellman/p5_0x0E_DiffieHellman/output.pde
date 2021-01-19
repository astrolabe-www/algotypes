void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.fill(COLOR_RED, 0, 0, 32);
  mpg.noStroke();

  float minX = (min(mpg.height, mpg.width) - max(mpg.height, mpg.width)) / 2.0;
  float maxX = min(mpg.height, mpg.width) - minX;
  float minY0 = -mpg.height / OUT_SCALE / 80;
  float maxY0 = mpg.height / OUT_SCALE / 40;
  float ellipseRadius = 2.0 * OUT_SCALE;

  randomSeed(1010);
  for (int n = 0; n < INPUT.length / 64; n++) {
    int aliceKeys[] = { (INPUT[n] ^ 0x00) & 0xff, int(random(0, 0xffff)) };
    int bbobbKeys[] = { (INPUT[n] ^ 0xff) & 0xff, int(random(0, 0xffff)) };

    DiffieHellman alice = new DiffieHellman(aliceKeys[0], aliceKeys[1]);
    DiffieHellman bbobb = new DiffieHellman(bbobbKeys[0], bbobbKeys[1]);

    alice.generatePartialKey(bbobb.publicKey);
    bbobb.generatePartialKey(alice.publicKey);

    alice.generateFullKey(bbobb.partialKey, bbobb.publicKey);
    bbobb.generateFullKey(alice.partialKey, alice.publicKey);

    if (alice.fullKey != bbobb.fullKey) {
      println(alice.fullKey + " != " + bbobb.fullKey);
    }

    float a = float(alice.publicKey);
    float b = float(bbobb.publicKey);
    float minX0 = 10e4;
    float maxX0 = -10e4;

    float[] x0s = new float[mpg.height];

    for (int y = 0; y < mpg.height; y++) {
      float y0 = map(y, 0, mpg.height, minY0, maxY0);
      float x0 = sqrt(y0 * y0 * y0 + a * y0 + b) % max(1, alice.fullKey);
      if (x0 < minX0) minX0 = x0;
      if (x0 > maxX0) maxX0 = x0;
      if (-x0 < minX0) minX0 = -x0;
      if (-x0 > maxX0) maxX0 = -x0;
      x0s[y] = x0;
    }
    minX0 = (abs(minX0) > 1e-5) ? minX0 : -1e-5;
    maxX0 = (abs(maxX0) > 1e-5) ? maxX0 : 1e-5;

    for (int y = 0; y < mpg.height; y++) {
      float x0 = x0s[y];
      if (x0 == x0) {
        float x = map(x0, minX0, maxX0, minX, maxX);
        float _x = map(-x0, minX0, maxX0, minX, maxX);
        mpg.ellipse(x, y, ellipseRadius, ellipseRadius);
        mpg.ellipse(_x, y, ellipseRadius, ellipseRadius);
      }
    }
  }
  mpg.endDraw();
}
