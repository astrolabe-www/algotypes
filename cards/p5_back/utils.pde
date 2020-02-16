PGraphics drawInputFramesToGraphics(int[] input) {
  PGraphics inG = createGraphics(width, height);

  inG.beginDraw();
  inG.rectMode(CENTER);

  inG.background(255, 0);

  for (int i = 0; i < input.length - 4; i += 4) {
    float x = map(input[i], 0, 256, 0, width);
    float y = map(input[i+1], 0, 256, 0, height);
    float w = map(input[i+2], 0, 256, width/20, width/4);
    float h = map(input[i+3], 0, 256, height/20, height/4);

    //inG.stroke(0, 0, 200, 32);
    //inG.fill(0, 0, 200, 16);
    inG.stroke(0, 32);
    inG.fill(0, 16);
    inG.rect(x, y, w, h);
    inG.rect(width - x, height - y, w, h);

    //inG.stroke(200, 0, 0, 32);
    //inG.fill(200, 0, 0, 16);
    inG.stroke(0, 32);
    inG.fill(0, 16);
    inG.rect(width - x, y, w, h);
    inG.rect(x, height - y, w, h);
  }
  inG.endDraw();
  return inG;
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
