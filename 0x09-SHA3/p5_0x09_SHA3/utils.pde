void drawInput(PGraphics mpg, String fileName) {
  byte in[] = loadBytes(fileName);

  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < in.length; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(in[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(in[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
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
  mpg.rect(mpg.width/2, bwidth, mpg.width - 2 * bwidth + 1, FONT_PADDING_FACTOR * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.number, mpg.width/2, OUT_SCALE * FONT_SIZE / 1.15);

  mpg.fill(255);
  mpg.rect(mpg.width/2, mpg.height - bwidth, mpg.width - 2 * bwidth + 1, FONT_PADDING_FACTOR * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.name, mpg.width/2, mpg.height - (OUT_SCALE * FONT_SIZE / 0.92));

  mpg.rectMode(CORNER);
  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(OUT_SCALE);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.rect(bwidth, bwidth + OUT_SCALE * (FONT_PADDING_FACTOR / 2.0) * FONT_SIZE, mpg.width - 2 * bwidth, mpg.height - 2 * bwidth - FONT_PADDING_FACTOR * OUT_SCALE * FONT_SIZE);

  mpg.endDraw();
}
