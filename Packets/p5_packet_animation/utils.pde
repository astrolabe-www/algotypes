int currentFile = 0;
int indexCounter = 0;
int wrapCounter = 0;
boolean clearBackground = false;

void drawInput(PGraphics mpg) {
  if (clearBackground) {
    drawOnePacket(mpg);
    if (random(1) > 0.99) clearBackground = !clearBackground;
  } else {
    int numPackets = (int)random(2, 8);
    for (int i = 0; i < numPackets; i++) {
      drawOnePacket(mpg);
    }
    if (random(1) > 0.997) clearBackground = !clearBackground;
  }
}

void drawOnePacket(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.noStroke();
  if (currentFile == 0) mpg.fill(0, 32);
  else if (currentFile % 2 == 1) mpg.fill(200, 0, 0, 32);
  else mpg.fill(0, 0, 200, 32);

  if (clearBackground) mpg.background(255);

  int packetsPerRow = 16;
  int packetWidth = ceil(mpg.width / packetsPerRow);

  int i = (indexCounter++) % INPUT[currentFile].length;

  float s = map(INPUT[currentFile][i], 0, 256, 0.08, 1);

  int xi = (i % packetsPerRow);
  int yi_raw = (i / packetsPerRow);
  int yi = (yi_raw) % ceil(mpg.height / float(packetWidth));

  mpg.pushMatrix();
  mpg.translate(packetWidth / 2, packetWidth / 2);
  mpg.rect(xi * packetWidth, yi * packetWidth, s * packetWidth, s * packetWidth);

  if (yi_raw > 4 * (mpg.height / packetWidth)) {
    indexCounter = 0;
    wrapCounter++;
    mpg.background(255);
    if (!clearBackground) clearBackground = !clearBackground;
    if (wrapCounter > 1) {
      wrapCounter = 0;
      currentFile = (currentFile + 1) % INPUT.length;
    }
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
