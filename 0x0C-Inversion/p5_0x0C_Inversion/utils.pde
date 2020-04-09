void drawInput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.background(255, 0);

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

  mpg.background(255, 0);
  mpg.stroke(200, 0, 0, 8);
  mpg.noStroke();
  mpg.fill(200, 0, 0, 32);

  LUPMatrix out = mLUPMatrix.inverted().inverted();

  float[][] outv = out.value;
  int size = out.size;
  float min = 0;
  float max = 0;

  for (int i = 0; i < outv.length; i++) {
    for (int j = 0; j < outv[i].length; j++) {
      if (outv[i][j] < min) min = outv[i][j];
      if (outv[i][j] > max) max = outv[i][j];
    }
  }

  for (int i = 0; i < outv.length * outv.length - 4; i += 4) {
    float x = map(outv[(i+0) / size][(i+0) % size], min, max, 0, mpg.width);
    float y = map(outv[(i+1) / size][(i+1) % size], min, max, 0, mpg.height);
    float w = map(outv[(i+2) / size][(i+2) % size], min, max, mpg.width/20, mpg.width/4);
    float h = map(outv[(i+3) / size][(i+3) % size], min, max, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
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