void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);

  mpg.background(255, 0);
  mpg.stroke(200, 0, 0, 8);
  mpg.noStroke();
  mpg.fill(200, 0, 0, 32);

  LUPMatrix out = mLUPMatrix.inverted().inverted();

  float[][] outv = out.value;
  int size = out.size;
  float min = 0;
  float max = 0;

  for (int i = 0; i < outv.length; i++) {
    for (int j = 0; j < outv[i].length; j++) {
      if (outv[i][j] < min) min = outv[i][j];
      if (outv[i][j] > max) max = outv[i][j];
    }
  }

  for (int i = 0; i < outv.length * outv.length - 4; i += 4) {
    float x = map(outv[(i+0) / size][(i+0) % size], min, max, 0, mpg.width);
    float y = map(outv[(i+1) / size][(i+1) % size], min, max, 0, mpg.height);
    float w = map(outv[(i+2) / size][(i+2) % size], min, max, mpg.width/20, mpg.width/4);
    float h = map(outv[(i+3) / size][(i+3) % size], min, max, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}
