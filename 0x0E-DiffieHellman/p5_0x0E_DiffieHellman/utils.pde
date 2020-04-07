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
  mpg.fill(200, 0, 0, (OUT_SCALE > 1) ? 32 : 64);
  mpg.noStroke();

  float minI = -mpg.width / OUT_SCALE / 64;
  float maxI = mpg.width / OUT_SCALE / 32;
  float ellipseRadius = (OUT_SCALE > 1) ? (2 * OUT_SCALE) : (4 * OUT_SCALE);

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
    float minJ = 10e4;
    float maxJ = -10e4;

    float[] js = new float[mpg.width];

    for (int x = 0; x < mpg.width; x++) {
      float i = map(x, 0, mpg.width, minI, maxI);
      float j = float(int(sqrt(i*i*i + a*i + b)) % max(1, alice.fullKey));
      if (j < minJ) minJ = j;
      if (j > maxJ) maxJ = j;
      if (-j < minJ) minJ = -j;
      if (-j > maxJ) maxJ = -j;
      js[x] = j;
    }
    minJ = (abs(minJ) > 1e-5) ? minJ : -1e-5;
    maxJ = (abs(maxJ) > 1e-5) ? maxJ : 1e-5;

    for (int x = 0; x < mpg.width; x++) {
      float j = js[x];
      float y = map(j, minJ, maxJ, 0, mpg.height);
      float _y = map(-j, minJ, maxJ, 0, mpg.height);
      mpg.ellipse(x, y, ellipseRadius, ellipseRadius);
      mpg.ellipse(x, _y, ellipseRadius, ellipseRadius);
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
