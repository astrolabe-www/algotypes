void drawInput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.strokeWeight(OUT_SCALE);
  mpg.stroke(0, 64);
  mpg.noStroke();
  mpg.fill(0, 32);

  int packetsPerRow = 16;
  int packetWidth = ceil(mpg.width / packetsPerRow);

  mpg.pushMatrix();
  mpg.translate(packetWidth / 2, packetWidth / 2);

  for (int i = 0; i < INPUT.length; i++) {
    int xi = (i % packetsPerRow);
    //int yi = (i / packetsPerRow) % ceil(mpg.height / float(packetWidth));
    int yi = (i / packetsPerRow);
    float s = map(INPUT[i], 0, 256, 0.05, 1);
    mpg.rect(xi * packetWidth, yi * packetWidth, s * packetWidth, s * packetWidth);
  }
  mpg.endDraw();
  mpg.popMatrix();
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
