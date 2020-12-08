void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.noFill();
  mpg.stroke(200, 0, 0, 200);
  mpg.strokeWeight(OUT_SCALE * 3.333);

  int maxD = max(mpg.height, mpg.width);
  Point[] inPoints = new Point[INPUT.length / 2];

  for (int p = 0; p < inPoints.length; p++) {
    float x = ((map(INPUT[2 * p + 0], 0, 255, 1, 2.0 * maxD)) % (mpg.width - 1.0));
    float y = ((map(INPUT[2 * p + 1], 0, 255, 1, 2.0 * maxD)) % (mpg.height - 1.0));
    inPoints[p] = new Point(x, y);
  }

  randomSeed(10100010);
  final int NUM_ROW = 7;
  final int NUM_COL = NUM_ROW * mpg.width / mpg.height;
  final float gridW = mpg.width / NUM_COL;
  final float gridH = mpg.height / NUM_ROW;
  final float gridScale = 4.0;

  Point[] inPolygon = new Point[INPUT.length];
  for (int p = 0; p < inPolygon.length; p++) inPolygon[p] = new Point(0, 0);

  for (int i = 0; i < NUM_ROW; i++) {
    for (int j = 0; j < NUM_COL; j++) {
      float xMin = (j + 0) * gridW + random(-gridW / gridScale, 0);
      float xMax = (j + 1) * gridW + random(0, gridW/ gridScale);
      float yMin = (i + 0) * gridH + random(-gridH / gridScale, 0);
      float yMax = (i + 1) * gridH + random(0, gridH / gridScale);

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
