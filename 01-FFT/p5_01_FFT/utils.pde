void drawInputFrames() {
  rectMode(CENTER);
  stroke(0, 200);
  fill(0, 0, 200, 16);
  fill(0, 32);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i], -256, 256, 0, width);
    float y = map(INPUT_FRAMES[i+1], -256, 256, 0, height);
    float w = map(INPUT_FRAMES[i+2], -256, 256, width/20, width/4);
    float h = map(INPUT_FRAMES[i+3], -256, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

void drawInputWave() {
  stroke(0, 64);
  strokeWeight(1);

  pushMatrix();
  translate(width/2, 0);

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    float x = map(INPUT_FRAMES[i], -(0xff), 0xff, -width/2, width/2);
    float y = map(i, 0, SIZE_INPUT_FRAMES, 0, height);
    line(0, y, x, y);
  }

  popMatrix();
}

void drawOutput() {
  rectMode(CENTER);
  stroke(0, 132);
  fill(255, 0, 0, 20);

  stroke(255, 0, 0, 64);
  strokeWeight(3);

  pushMatrix();
  translate(width/2, 0);

  for (int i = 0; i < OUTPUT_FFT.length; i++) {
    float mag = OUTPUT_FFT[i].magnitude() / OUTPUT_FFT.length;
    float x = map(mag, 0, 0xff, 1, width / 0.5);
    float y = map(i, 0, OUTPUT_FFT.length, 0, height);
    line(-x, y, x, y);
  }

  popMatrix();
}

void drawBorders(int bwidth) {
  rectMode(CORNER);
  stroke(255);
  fill(255);
  rect(0, 0, width, bwidth);
  rect(0, height-bwidth-1, width, bwidth);
  rect(0, 0, bwidth, height);
  rect(width-bwidth-1, 0, bwidth, height);

  noFill();
  stroke(10);
  rect(1, 1, width-3, height-3);
}
