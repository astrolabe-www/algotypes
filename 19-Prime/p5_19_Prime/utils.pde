void drawInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  rectMode(CENTER);
  stroke(0, 200);
  fill(0, 0, 200, 16);
  fill(0, 32);

  for (int i = 0; i < in.length; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, height);
    float w = map(in[i+2] & 0xff, 0, 256, width/20, width/4);
    float h = map(in[i+3] & 0xff, 0, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

void drawOutput() {
  rectMode(CENTER);
  stroke(0, 132);
  fill(255, 0, 0, 20);
  // TODO
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
