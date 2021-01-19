final boolean VMAJOR_MEM = true;
final int INPUT_ROUNDS = 1;

void drawOutput(PGraphics mpg) {
  byte[] mField;
  ArrayList<PGraphics> mPGs = new ArrayList<PGraphics>();

  mpg.beginDraw();

  for (int i = 0; i < INPUT_ROUNDS * INPUT.length; i++) {
    mField = mVM.step(INPUT[i % INPUT.length]);

    if (mVM.needsMarkSweep()) {
      PGraphics tmpPG = createGraphics(mpg.width, mpg.height);

      tmpPG.beginDraw();
      tmpPG.background(255, 0);

      tmpPG.pushMatrix();
      tmpPG.translate(0, tmpPG.height / 2.0);
      drawField(tmpPG, mField, VMAJOR_MEM);
      tmpPG.popMatrix();

      mField = mVM.markSweep();

      drawField(tmpPG, mField, VMAJOR_MEM);
      tmpPG.endDraw();

      mPGs.add(tmpPG);
    }
  }

  mpg.pushMatrix();
  for (PGraphics tmpPG : mPGs) {
    mpg.image(tmpPG, 0, 0, mpg.width / (mPGs.size() - 1), mpg.height);
    mpg.translate(mpg.width / (mPGs.size() - 1), 0);
  }
  mpg.popMatrix();
  mpg.endDraw();
}

void drawField(PGraphics mpg, byte[] field, boolean vMajor) {
  float maxX = floor(sqrt(field.length));
  float maxY = floor(field.length / maxX);
  float wScale = 1.0;
  float hScale = 2.0;

  mpg.rectMode(CORNER);
  mpg.ellipseMode(CORNER);
  mpg.noStroke();

  for (int y = 0; y < maxY; y++) {
    for (int x = 0; x < maxX; x++) {
      int a = vMajor ? field[int(maxX * x + y)] & 0xff : field[int(maxX * y + x)] & 0xff;
      mpg.fill(COLOR_RED, 0, 0, a);
      mpg.rect((x / maxX) * (mpg.width / wScale), (y / maxY) * (mpg.height / hScale),
        (mpg.width / wScale) / maxX, (mpg.height / hScale) / maxY);
    }
  }
}
