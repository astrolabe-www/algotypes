void drawInputWave(PGraphics mpg) {
  int WAVE_LENGTH = INPUT.length / 4;
  noiseSeed(10108010);

  mpg.beginDraw();
  mpg.stroke(0, 64);
  mpg.strokeWeight(OUT_SCALE);

  mpg.pushMatrix();
  mpg.translate(mpg.width/2, 0);

  for (int i = 0; i < WAVE_LENGTH; i++) {
    float v = 0xff * (2.0 * noise(i/1e2) - 1.0);
    float x = map(v, -256, 256, -mpg.width / 2, mpg.width / 2);
    float y = map(i, 0, WAVE_LENGTH, 0, mpg.height);
    mpg.line(0, y, x, y);
  }

  mpg.popMatrix();
  mpg.endDraw();
}

void drawOutputWave(PGraphics mpg) {
  mpg.beginDraw();

  mpg.noFill();
  mpg.stroke(COLOR_RED, 0, 0, 176);
  mpg.strokeWeight(OUT_SCALE);

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

void drawOutput(PGraphics mpg) {
  drawInputWave(mpg);
  drawOutputWave(mpg);
}
