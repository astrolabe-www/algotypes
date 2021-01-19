void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.fill(COLOR_RED, 0, 0);
  mpg.noStroke();

  float[] e = mPID.getErrors();

  int AVG_SIZE = 255;
  int avg_index = (AVG_SIZE / 2);
  float avg_sum = 0;
  float[] avg = new float[AVG_SIZE];

  PVector[] backVertices = new PVector[e.length];
  for (int i = 0; i < AVG_SIZE; i ++) {
    avg_sum += e[i];
  }

  mpg.beginShape();
  mpg.vertex(0, mpg.height / 2);
  for (int i = (AVG_SIZE / 2); i < e.length; i++) {
    avg_sum -= avg[avg_index];
    avg[avg_index] = abs(e[i]);
    avg_sum += avg[avg_index];
    avg_index = (avg_index + 1) % avg.length;

    float x = map(i, 0, e.length, 0, mpg.width);
    float y0 = (mpg.height / 64) * cos(x * (PI / 2.125) / mpg.width) * (avg_sum / AVG_SIZE);
    float y1 = (mpg.height / 64) * cos(x * (PI / 2.125) / mpg.width) * e[i];

    mpg.vertex(x, mpg.height / 2 - abs(y0));
    backVertices[i] = new PVector(x, mpg.height / 2 + abs(y1));
  }

  for (int i = backVertices.length - 1; i >= (AVG_SIZE / 2); i--) {
    mpg.vertex(backVertices[i].x, backVertices[i].y);
  }

  mpg.vertex(0, mpg.height / 2);
  mpg.endShape();
  mpg.endDraw();
}
