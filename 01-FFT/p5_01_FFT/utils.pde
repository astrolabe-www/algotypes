void drawInputFrames(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i], -256, 256, 0, mpg.width);
    float y = map(INPUT_FRAMES[i+1], -256, 256, 0, mpg.height);
    float w = map(INPUT_FRAMES[i+2], -256, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT_FRAMES[i+3], -256, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.fill(200, 0, 0, 16);
  mpg.stroke(200, 0, 0, 128);
  mpg.strokeWeight(OUT_SCALE * 1);

  mpg.pushMatrix();
  mpg.translate(mpg.width / 2, 0);

  for (int i = 0; i < OUTPUT_FFT.length; i++) {
    float mag = OUTPUT_FFT[i].magnitude() / OUTPUT_FFT.length;
    float x = map(mag, 0, 0xff, 1, 2 * mpg.width);
    float y = map(i, 0, OUTPUT_FFT.length, 0, mpg.height);
    mpg.line(-x, y, x, y);
  }
  mpg.popMatrix();
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

void drawInputWave(PGraphics mpg) {
  mpg.beginDraw();
  mpg.stroke(0, 64);
  mpg.strokeWeight(OUT_SCALE);

  mpg.pushMatrix();
  mpg.translate(mpg.width/2, 0);

  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    float x = map(INPUT_NOISE[i], -(0xff), 0xff, -mpg.width / 2, mpg.width / 2);
    float y = map(i, 0, SIZE_INPUT_NOISE, 0, mpg.height);
    mpg.line(0, y, x, y);
  }

  mpg.popMatrix();
  mpg.endDraw();
}
