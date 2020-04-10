void drawInput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < INPUT.length; i += 4) {
    float x = map(INPUT[i+0], 0, 256, 0, mpg.width);
    float y = map(INPUT[i+1], 0, 256, 0, mpg.height);
    float w = map(INPUT[i+2], 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT[i+3], 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.noFill();
  mpg.stroke(200, 0, 0, 200);
  mpg.strokeWeight(OUT_SCALE * 1.333);

  int maxD = max(mpg.height, mpg.width);
  int RBWIDTH = OUT_SCALE * BORDER_WIDTH;
  Point[] inPoints = new Point[INPUT.length / 2];

  for (int p = 0; p < inPoints.length; p++) {
    float x = ((map(INPUT[2 * p + 0], 0, 255, 0, 2.0 * maxD)) % (mpg.width - 2.0 * RBWIDTH)) + 1.1 * RBWIDTH;
    float y = ((map(INPUT[2 * p + 1], 0, 255, 0, 2.0 * maxD)) % (mpg.height - 2.0 * RBWIDTH)) + 1.1 * RBWIDTH;
    inPoints[p] = new Point(x, y);
  }

  randomSeed(101010);
  final int NUM_ROW = 8;
  final int NUM_COL = NUM_ROW * mpg.width / mpg.height;
  final float gridW = mpg.width / NUM_COL;
  final float gridH = mpg.height / NUM_ROW;

  Point[] inPolygon = new Point[INPUT.length];
  for (int p = 0; p < inPolygon.length; p++) inPolygon[p] = new Point(0, 0);

  for (int i = 0; i < NUM_ROW; i++) {
    for (int j = 0; j < NUM_COL; j++) {
      float xMin = (j + 0) * gridW + random(-gridW / 10.0, 0);
      float xMax = (j + 1) * gridW + random(0, gridW/ 10.0);
      float yMin = (i + 0) * gridH + random(-gridH / 10.0, 0);
      float yMax = (i + 1) * gridH + random(0, gridH / 10.0);

      int pCount = 0;

      for (int p = 0; p < inPoints.length; p++) {
        float xDist = inPoints[p].x;
        float yDist = inPoints[p].y;
        if (xDist >= xMin && xDist <= xMax && yDist >= yMin && yDist <= yMax) {
          inPolygon[pCount].x = inPoints[p].x;
          inPolygon[pCount].y = inPoints[p].y;
          pCount++;
        }
      }

      Point[] prunedInPolygon = new Point[pCount];
      for (int p = 0; p < prunedInPolygon.length; p++) prunedInPolygon[p] = inPolygon[p];
      Point[] outPolygon = Convex.Hull(prunedInPolygon);

      mpg.beginShape();
      for (int p = 0; p < outPolygon.length; p++) mpg.vertex(outPolygon[p].x, outPolygon[p].y);
      mpg.endShape(CLOSE);
    }
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

  mpg.noStroke();
  mpg.textFont(mFont);
  mpg.textSize(OUT_SCALE * FONT_SIZE);
  mpg.rectMode(CENTER);
  mpg.textAlign(CENTER, CENTER);
  mpg.fill(255);
  mpg.rect(mpg.width/2, bwidth, 1.111 * mpg.textWidth(Card.number), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.number, mpg.width/2, OUT_SCALE * FONT_SIZE / 2);

  mpg.fill(255);
  mpg.rect(mpg.width/2, mpg.height - bwidth, 1.111 * mpg.textWidth(Card.name), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.name, mpg.width/2, mpg.height - OUT_SCALE * 32);

  mpg.rectMode(CORNER);
  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(1);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.endDraw();
}
