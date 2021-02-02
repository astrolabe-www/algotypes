void drawOutput(PGraphics mpg) {
  float PWIDTH = OUT_SCALE * 4;
  float NOISE_SCALE = 1.0 / (OUT_SCALE * 64f);

  mpg.beginDraw();
  mpg.rectMode(CENTER);

  for (int x = 0; x < mpg.width + PWIDTH; x += PWIDTH) {
    for (int y = 0; y < mpg.height + PWIDTH; y += PWIDTH) {
      int alpha = int(255f * mPerlin.noise(x * NOISE_SCALE, y * NOISE_SCALE));

      mpg.stroke(COLOR_RED, 0, 0, alpha);
      mpg.strokeWeight(OUT_SCALE / 2.0);
      mpg.fill(COLOR_RED, 0, 0, alpha / 2.0);

      mpg.rect(x, y,
        1.5 * (PWIDTH + OUT_SCALE) * mPerlin.noise(x * NOISE_SCALE, y * NOISE_SCALE, PI),
        1.5 * (PWIDTH + OUT_SCALE) * mPerlin.noise(x * NOISE_SCALE, y * NOISE_SCALE, TWO_PI));
    }
  }
  mpg.endDraw();
}

void saveOutput(String filename) {
  float NOISE_SCALE = 1.0 / (OUT_SCALE * 8f);
  byte[] out = new byte[INPUT.length];
  for (int i = 0; i < out.length; i += 1) {
    out[i] = (byte)((int)(255f * mPerlin.noise(i * NOISE_SCALE)) & 0xff);
  }
  saveBytes(filename, out);
}
