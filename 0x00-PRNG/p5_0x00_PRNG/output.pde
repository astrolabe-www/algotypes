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
