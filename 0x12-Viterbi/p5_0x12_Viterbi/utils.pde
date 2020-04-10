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
  mFSM.calculate(INPUT);

  mpg.beginDraw();

  mpg.rectMode(CORNER);
  mpg.fill(200, 0, 0, 64);
  mpg.stroke(200, 0, 0, 64);
  mpg.strokeWeight(OUT_SCALE * 1);

  for (int s = 1; s < mFSM.F.length; s++) {
    for (int f = 0; f < mFSM.NUMBER_STATES; f++) {
      for (int t = 0; t < mFSM.NUMBER_STATES; t++) {
        float x0 = map(f, 0, mFSM.NUMBER_STATES - 1, OUT_SCALE * BORDER_WIDTH, mpg.width - OUT_SCALE * BORDER_WIDTH);
        float y0 = map(s - 1, 0, mFSM.out.length - 1, OUT_SCALE * BORDER_WIDTH, mpg.height - OUT_SCALE * BORDER_WIDTH);
        float x1 = map(t, 0, mFSM.NUMBER_STATES - 1, OUT_SCALE * BORDER_WIDTH, mpg.width - OUT_SCALE * BORDER_WIDTH);
        float y1 = map(s, 0, mFSM.out.length - 1, OUT_SCALE * BORDER_WIDTH, mpg.height - OUT_SCALE * BORDER_WIDTH);

        if (!((s >= mFSM.F.length / 2 - 1) && (s <= mFSM.F.length / 2 + 1))) {
        //if (s % 2 == 0) {
          float a = map(mFSM.transition[s][f][t], 0, 1, 0, 96 * 2);
          mpg.stroke(200, 0, 0, a);
          mpg.line(x0, y0, x1, y1);

          a = map(mFSM.transitionProbability[f][t], 0, 1, 0, 255 * 2);
          mpg.stroke(200, 0, 0, a);
          mpg.line(x0, y0, x1, y1);
        } else {
          float a = 32 * 2;
          mpg.stroke(200, 0, 0, a);
          mpg.line(x0, y0, x1, y1);
        }
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
