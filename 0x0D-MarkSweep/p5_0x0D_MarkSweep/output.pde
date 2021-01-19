void drawOutput(PGraphics mpg) {
  byte[] mField;

  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.noStroke();
  mpg.fill(255, 0, 0, 20);

  for (int i = 0; i < INPUT.length; i++) {
    mField = mVM.step(INPUT[i % INPUT.length]);

    if (mVM.needsMarkSweep()) {
      mpg.background(255);
      drawField(mpg, mField);

      mField = mVM.markSweep();

      mpg.pushMatrix();
      mpg.translate(mpg.width / 2.0, 0);
      drawField(mpg, mField);
      mpg.popMatrix();
    }
  }
  mpg.endDraw();
}

void drawField(PGraphics mpg, byte[] field) {
  float maxX = floor(sqrt(field.length));
  float maxY = floor(field.length / maxX);

  for (int y = 0; y < maxY; y++) {
    for (int x = 0; x < maxX; x++) {
      int a = field[int(maxX * y + x)] & 0xff;
      mpg.fill(255, 0, 0, a);
      mpg.rect((x / maxX) * (mpg.width / 2.0), (y / maxY) * mpg.height, (mpg.width / 2.0) / maxX, mpg.height / maxY);
    }
  }
}
