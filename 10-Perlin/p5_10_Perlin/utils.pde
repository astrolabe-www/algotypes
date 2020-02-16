void drawInputFrames() {
  rectMode(CENTER);
  stroke(0, 32);
  fill(0, 0, 200, 16);
  fill(0, 16);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i], 0, 256, 0, width);
    float y = map(INPUT_FRAMES[i+1], 0, 256, 0, height);
    float w = map(INPUT_FRAMES[i+2], 0, 256, width/20, width/4);
    float h = map(INPUT_FRAMES[i+3], 0, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

void drawOutput() {
  rectMode(CENTER);
  int PWIDHT = 3;

  for (float x = 0; x < width + PWIDHT; x += PWIDHT) {
    for (float y = 0; y < height + PWIDHT; y += PWIDHT) {
      int c = int(255f * mPerlin.noise(x/100f, y/100f, PI/8f));

      stroke(255, 0, 0, c);
      fill(255, 0, 0, c);

      rect(x, y,
        1.5*(PWIDHT+1)*mPerlin.noise(x/100f, y/100f, PI),
        1.5*(PWIDHT+1)*mPerlin.noise(x/100f, y/100f, TWO_PI));
    }
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
  rect(1, 1, width - 2, height - 2);
}
