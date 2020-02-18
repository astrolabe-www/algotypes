void drawInputFrames(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i+0], 0, 256, 0, mpg.width);
    float y = map(INPUT_FRAMES[i+1], 0, 256, 0, mpg.height);
    float w = map(INPUT_FRAMES[i+2], 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT_FRAMES[i+3], 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  int PWIDTH = OUT_SCALE * 3;

  mpg.beginDraw();
  mpg.rectMode(CENTER);

  for (float x = 0; x < mpg.width + PWIDTH; x += PWIDTH) {
    for (float y = 0; y < mpg.height + PWIDTH; y += PWIDTH) {
      int c = int(255f * mPerlin.noise(x/(OUT_SCALE*100f), y/(OUT_SCALE*100f), PI/8f));

      mpg.stroke(255, 0, 0, c);
      mpg.strokeWeight(OUT_SCALE / 2);
      mpg.fill(255, 0, 0, c / 2);

      mpg.rect(x, y,
        1.5*(PWIDTH + OUT_SCALE)*mPerlin.noise(x/(OUT_SCALE*100f), y/(OUT_SCALE*100f), PI),
        1.5*(PWIDTH + OUT_SCALE)*mPerlin.noise(x/(OUT_SCALE*100f), y/(OUT_SCALE*100f), TWO_PI));
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

  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(1);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.endDraw();
}
