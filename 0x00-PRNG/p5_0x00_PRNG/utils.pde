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
  mpg.rectMode(CENTER);
  mpg.stroke(0, 128);
  mpg.strokeWeight(OUT_SCALE / 2);
  mpg.fill(255, 0, 0, 20);

  for (int i = 0; i < INPUT.length; i += 1) {
    float x = map(mPRNG.random(), 0, 256, 0, mpg.width);
    float y = map(mPRNG.random(), 0, 256, 0, mpg.height);
    float w = map(mPRNG.random(), 0, 256, 16, 100);
    float h = map(mPRNG.random(), 0, 256, 16, 100);
    mpg.rect(x, y, OUT_SCALE * w, OUT_SCALE * h);
  }
  mpg.endDraw();
}

void saveOutput(String filename) {
  byte[] out = new byte[INPUT.length];
  for (int i = 0; i < out.length; i += 1) {
    out[i] = (byte)(mPRNG.random() & 0xff);
  }
  saveBytes(filename, out);
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
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);

  mpg.endDraw();
}
