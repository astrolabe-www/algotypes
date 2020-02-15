PGraphics drawInputFramesToGraphics() {
  PGraphics inG = createGraphics(width, height);

  inG.beginDraw();
  inG.rectMode(CENTER);

  inG.background(255, 0);
  inG.stroke(0, 200);
  inG.fill(0, 32);

  //inG.stroke(0, 0, 200, 32);
  //inG.fill(0, 0, 200, 16);

  for (int i = 0; i < SIZE_INPUT_FRAMES - 4; i += 4) {
    float x = map(INPUT_FRAMES[i], 0, 256, 0, width);
    float y = map(INPUT_FRAMES[i+1], 0, 256, 0, height);
    float w = map(INPUT_FRAMES[i+2], 0, 256, width/20, width/4);
    float h = map(INPUT_FRAMES[i+3], 0, 256, height/20, height/4);
    inG.rect(x, y, w, h);
  }
  inG.endDraw();
  return inG;
}

PGraphics drawOutputToGraphics() {
  PGraphics outG = createGraphics(width, height);

  outG.beginDraw();
  outG.rectMode(CENTER);

  outG.background(255, 10);
  outG.stroke(200, 0, 0, 8);
  outG.fill(200, 0, 0, 32);

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
    float x = map(outv[(i+0) / size][(i+0) % size], min, max, 0, width);
    float y = map(outv[(i+1) / size][(i+1) % size], min, max, 0, height);
    float w = map(outv[(i+2) / size][(i+2) % size], min, max, width/20, width/4);
    float h = map(outv[(i+3) / size][(i+3) % size], min, max, height/20, height/4);
    outG.rect(x, y, w, h);
  }
  outG.endDraw();

  return outG;
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
