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

  mpg.noStroke();
  mpg.fill(200, 0, 0, 16);
  mpg.strokeWeight(OUT_SCALE * 1);

  int maxD = max(mpg.height, mpg.width);
  int RBWIDTH = OUT_SCALE * BORDER_WIDTH;
  Point[] inPoints = new Point[INPUT.length / 2];

  for (int p = 0; p < INPUT.length / 2; p++) {
    float x = ((map(INPUT[2 * p + 0], 0, 255, 0, 2.0 * maxD)) % (mpg.width - 2.0 * RBWIDTH)) + 1.1 * RBWIDTH;
    float y = ((map(INPUT[2 * p + 1], 0, 255, 0, 2.0 * maxD)) % (mpg.height - 2.0 * RBWIDTH)) + 1.1 * RBWIDTH;
    inPoints[p] = new Point(x, y);
    mpg.ellipse(x, y, 4, 4);
  }

  final int NUMBER_OF_POLYGONS = 16;
  final int pointsPerPolygon = inPoints.length / NUMBER_OF_POLYGONS;
  Point[] inPolygon = new Point[pointsPerPolygon];

  for (int polygon = 0; polygon < NUMBER_OF_POLYGONS; polygon++) {
    for (int point = 0; point < pointsPerPolygon; point++) {
      inPolygon[point] = inPoints[polygon * pointsPerPolygon + point];
    }

    Point[] outPolygon = Convex.Hull(inPolygon);

    mpg.beginShape();
    for (int point = 0; point < pointsPerPolygon; point++) {
      float x = outPolygon[point].x;
      float y = outPolygon[point].y;
      if (x != 0 || y != 0) mpg.vertex(x, y);
    }
    mpg.endShape(CLOSE);
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
