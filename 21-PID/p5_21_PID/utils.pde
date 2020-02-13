void drawInputFrames() {
  rectMode(CENTER);
  stroke(0, 200);
  fill(0, 32);
  //noStroke();
  //fill(0, 0, 200, 16);

  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, height);
    float w = map(in[i+2] & 0xff, 0, 256, width/20, width/4);
    float h = map(in[i+3] & 0xff, 0, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

void drawOutput() {
  rectMode(CENTER);
  strokeCap(PROJECT);
  stroke(0, 132);
  fill(255, 0, 0, 20);
  stroke(255, 0, 0, 32);

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

    float x = map(i, 0, e.length, 0, width);

    float y0 = (height / 64) * cos(x * (PI / 2.125) / width) * (avg_sum / AVG_SIZE);
    float y1 = (height / 64) * cos(x * (PI / 2.125) / width) * e[i];

    line(x, height / 2 - 1, x, height / 2 - abs(y0));
    line(x, height / 2, x, height / 2 + abs(y1));
  }
}

void drawBorders(int bwidth) {
  rectMode(CORNER);
  stroke(255);
  fill(255);
  rect(0, 0, width, bwidth);
  rect(0, height-bwidth, width, bwidth);
  rect(0, 0, bwidth, height);
  rect(width-bwidth, 0, bwidth, height);

  noFill();
  stroke(10);
  rect(1, 1, width-2, height-2);
}
