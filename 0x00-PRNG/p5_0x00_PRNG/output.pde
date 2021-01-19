void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.stroke(0, 128);
  mpg.strokeWeight(OUT_SCALE / 2);
  mpg.fill(COLOR_RED, 0, 0, 20);

  for (int i = 0; i < INPUT.length / 2; i += 1) {
    float w = map(mPRNG.random(), 0, 256, mpg.width / 20, mpg.width / 4);
    float h = map(mPRNG.random(), 0, 256, mpg.height / 20, mpg.height / 4);
    float x = map(mPRNG.random(), 0, 256, 0 - 0.25 * w, mpg.width - 0.75 * w);
    float y = map(mPRNG.random(), 0, 256, 0 - 0.25 * h, mpg.height - 0.75 * h);
    mpg.rect(x, y, w, h);
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
