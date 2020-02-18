void drawInputFrames(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);

  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(in[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(in[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.strokeCap(PROJECT);
  mpg.stroke(0, 132);
  mpg.fill(255, 0, 0, 20);
  mpg.stroke(255, 0, 0, 32);
  mpg.strokeWeight(OUT_SCALE);

  float[] e = mPID.getErrors();

  int AVG_SIZE = 255;
  int avg_index = (AVG_SIZE / 2);
  float avg_sum = 0;
  float[] avg = new float[AVG_SIZE];

  for(int i = 0; i < AVG_SIZE; i ++) {
    avg_sum += e[i];
  }

  for (int i = (AVG_SIZE / 2); i < e.length; i++) {
    avg_sum -= avg[avg_index];
    avg[avg_index] = abs(e[i]);
    avg_sum += avg[avg_index];
    avg_index = (avg_index + 1) % avg.length;

    float x = map(i, 0, e.length, 0, mpg.width);

    float y0 = (mpg.height / 64) * cos(x * (PI / 2.125) / mpg.width) * (avg_sum / AVG_SIZE);
    float y1 = (mpg.height / 64) * cos(x * (PI / 2.125) / mpg.width) * e[i];

    mpg.line(x, mpg.height / 2 - 1, x, mpg.height / 2 - abs(y0));
    mpg.line(x, mpg.height / 2, x, mpg.height / 2 + abs(y1));
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
