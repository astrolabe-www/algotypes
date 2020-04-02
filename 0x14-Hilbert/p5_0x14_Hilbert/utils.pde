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
  randomSeed(101010);

  float mX[] = { max(mpg.width, mpg.height) };
  float mY[] = { max(mpg.width, mpg.height) };
  int borderOffset = OUT_SCALE * (BORDER_WIDTH + 4);
  int rness = 4;

  int N[][] = {
    { 16 },
    { 16 },
    { 16 },
    { 16, 16, 3, 16, 16, 16, 3, 3, 10, 10 }
  };

  mpg.beginDraw();
  mpg.stroke(200, 0, 0, 128);
  mpg.strokeWeight(OUT_SCALE);
  mpg.noFill();

  for (int ni = 0; ni < N.length; ni++) {
    for (int i = 0; i < INPUT.length; i++) {
      Hilbert.N = N[ni][INPUT[i] % N[ni].length];

      PVector xy0 = Hilbert.d2xy(INPUT[i]);
      PVector xy1 = Hilbert.d2xy((INPUT[i] + 1) % 256);

      float x0 = map(xy0.x, 0, Hilbert.N - 1, borderOffset, mX[i % mX.length] - borderOffset);
      float y0 = map(xy0.y, 0, Hilbert.N - 1, borderOffset, mY[i % mY.length] - borderOffset);
      float x1 = map(xy1.x, 0, Hilbert.N - 1, borderOffset, mX[i % mX.length] - borderOffset);
      float y1 = map(xy1.y, 0, Hilbert.N - 1, borderOffset, mY[i % mY.length] - borderOffset);

      mpg.bezier(x0, y0,
                 lerp(x0 + random(-rness, rness), x1 + random(-rness, rness), random(0, 1)), lerp(y0 + random(-rness, rness), y1 + random(-rness, rness), random(0, 1)),
                 lerp(x0 + random(-rness, rness), x1 + random(-rness, rness), random(0, 1)), lerp(y0 + random(-rness, rness), y1 + random(-rness, rness), random(0, 1)),
                 x1, y1);
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
