void drawOutput(PGraphics mpg) {

  int maxD = max(mpg.height, mpg.width);
  Point[] inPoints = new Point[INPUT.length / 2];

  for (int p = 0; p < inPoints.length; p++) {
    float x = map(INPUT[2 * p + 0], 0, 255, 1, mpg.width);
    float y = map(INPUT[2 * p + 1], 0, 255, 1, mpg.height);
    inPoints[p] = new Point(x, y);
  }

  mpg.beginDraw();
  mpg.background(255);
  mpg.noFill();
  mpg.stroke(200, 0, 0, 200);
  mpg.strokeWeight(OUT_SCALE * 3);
  mpg.endDraw();

  drawOutputOnion(mpg, inPoints);
  //drawOutputGrid(mpg, inPoints);
}

void drawOutputOnion(PGraphics mpg, Point[] inPoints) {
  final int NUM_ROUNDS = 17;
  final float STEPX = 0.5 * mpg.height / NUM_ROUNDS;
  final float STEPY = 0.5 * mpg.height / NUM_ROUNDS;
  final float CX = mpg.width / 2f;
  final float CY = mpg.height / 2f;

  ArrayList<Point> inPolygon = new ArrayList<Point>();

  mpg.beginDraw();

  for (int i = NUM_ROUNDS; i > 0; i--) {
    float limitSq = (i * STEPX * i * STEPY);
    inPolygon.clear();
    for (int p = 0; p < inPoints.length; p++) {
      float px = inPoints[p].x;
      float py = inPoints[p].y;
      float distSq = (CX - px) * (CX - px) + (CY - py) * (CY - py);
      if(distSq < limitSq) inPolygon.add(new Point(px, py));
    }

    Point[] outPolygon = Convex.Hull(inPolygon.toArray(new Point[inPolygon.size()]));

    mpg.beginShape();
    for (int p = 0; p < outPolygon.length; p++) mpg.vertex(outPolygon[p].x, outPolygon[p].y);
    mpg.endShape(CLOSE);
  }
  mpg.endDraw();
}


void drawOutputGrid(PGraphics mpg, Point[] inPoints) {
  randomSeed(10100010);
  final int NUM_ROW = 7;
  final int NUM_COL = NUM_ROW * mpg.width / mpg.height;
  final float gridW = mpg.width / NUM_COL;
  final float gridH = mpg.height / NUM_ROW;
  final float gridScale = 4.0;

  ArrayList<Point> inPolygon = new ArrayList<Point>();

  mpg.beginDraw();
  for (int i = 0; i < NUM_ROW; i++) {
    for (int j = 0; j < NUM_COL; j++) {
      float xMin = (j + 0) * gridW + random(-gridW / gridScale, 0);
      float xMax = (j + 1) * gridW + random(0, gridW/ gridScale);
      float yMin = (i + 0) * gridH + random(-gridH / gridScale, 0);
      float yMax = (i + 1) * gridH + random(0, gridH / gridScale);

      inPolygon.clear();
      for (int p = 0; p < inPoints.length; p++) {
        float xDist = inPoints[p].x;
        float yDist = inPoints[p].y;
        if (xDist >= xMin && xDist <= xMax && yDist >= yMin && yDist <= yMax) {
          inPolygon.add(new Point(inPoints[p].x, inPoints[p].y));
        }
      }

      Point[] outPolygon = Convex.Hull(inPolygon.toArray(new Point[inPolygon.size()]));

      mpg.beginShape();
      for (int p = 0; p < outPolygon.length; p++) mpg.vertex(outPolygon[p].x, outPolygon[p].y);
      mpg.endShape(CLOSE);
    }
  }
  mpg.endDraw();
}
