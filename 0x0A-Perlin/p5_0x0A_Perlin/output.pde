void drawOutput(PGraphics mpg) {
  int PWIDTH = OUT_SCALE * 3;
  float NOISE_SCALE = 1.0 / (OUT_SCALE * 128f);

  mpg.beginDraw();
  mpg.rectMode(CENTER);

  for (float x = 0; x < mpg.width + PWIDTH; x += PWIDTH) {
    for (float y = 0; y < mpg.height + PWIDTH; y += PWIDTH) {
      int c = int(255f * mPerlin.noise(x * NOISE_SCALE, y * NOISE_SCALE));

      mpg.stroke(255, 0, 0, c);
      mpg.strokeWeight(OUT_SCALE / 2);
      mpg.fill(255, 0, 0, c / 2);

      mpg.rect(x, y,
        1.5*(PWIDTH + OUT_SCALE)*mPerlin.noise(x * NOISE_SCALE, y * NOISE_SCALE, PI),
        1.5*(PWIDTH + OUT_SCALE)*mPerlin.noise(x * NOISE_SCALE, y * NOISE_SCALE, TWO_PI));
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
