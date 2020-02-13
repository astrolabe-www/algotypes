void drawInputFrames() {
  rectMode(CENTER);
  stroke(0, 200);
  fill(0, 0, 200, 16);
  fill(0, 32);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i], 0, 256, 0, width);
    float y = map(INPUT_FRAMES[i+1], 0, 256, 0, height);
    float w = map(INPUT_FRAMES[i+2], 0, 256, width/20, width/4);
    float h = map(INPUT_FRAMES[i+3], 0, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

void drawOutput() {
  drawOutput00();
}

void drawOutput01() {
  rectMode(CENTER);
  stroke(255, 0, 0, 250);
  fill(255, 0, 0, 250);
  int WH = 8;

  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 1) {
    float x = map(mPRNG.random(), 0, 256, 0, width);
    float y = map(mPRNG.random(), 0, 256, 0, height);
    rect(x, y, WH, WH);
  }
}

void drawOutput00() {
  rectMode(CENTER);
  stroke(0, 128);
  fill(255, 0, 0, 20);

  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 1) {
    float x = map(mPRNG.random(), 0, 256, 0, width);
    float y = map(mPRNG.random(), 0, 256, 0, height);
    float w = map(mPRNG.random(), 0, 256, 16, 100);
    float h = map(mPRNG.random(), 0, 256, 16, 100);
    rect(x, y, w, h);
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
  rect(1, 1, width-3, height-3);
}
