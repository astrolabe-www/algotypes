void drawInput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < INPUT.length; i += 4) {
    float x = map(INPUT[i+0], 0, 256, 0, mpg.width);
    float y = map(INPUT[i+1], 0, 256, 0, mpg.height);
    float w = map(INPUT[i+2], 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT[i+3], 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.fill(200, 0, 0, 32);
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

void drawBorders(PGraphics mpg, int bwidth) {
  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.stroke(255);
  mpg.fill(255);
  mpg.rect(0, 0, mpg.width, bwidth);
  mpg.rect(0, mpg.height - bwidth, mpg.width, bwidth);
  mpg.rect(0, 0, bwidth, mpg.height);
  mpg.rect(mpg.width - bwidth, 0, bwidth, mpg.height);

  mpg.noStroke();
  mpg.textFont(mFont);
  mpg.textSize(OUT_SCALE * FONT_SIZE);
  mpg.rectMode(CENTER);
  mpg.textAlign(CENTER, CENTER);
  mpg.fill(255);
  mpg.rect(mpg.width/2, bwidth, 1.111 * mpg.textWidth(Card.number), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.number, mpg.width/2, OUT_SCALE * FONT_SIZE / 2);

  mpg.fill(255);
  mpg.rect(mpg.width/2, mpg.height - bwidth, 1.111 * mpg.textWidth(Card.name), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.name, mpg.width/2, mpg.height - OUT_SCALE * 32);

  mpg.rectMode(CORNER);
  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(1);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.endDraw();
}
