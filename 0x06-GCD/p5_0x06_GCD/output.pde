void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CORNER);
  mpg.stroke(200, 0, 0, 64);
  mpg.fill(200, 0, 0, 96);
  mpg.strokeWeight(OUT_SCALE * 1);

  int maxA = 0;
  int maxB = 0;
  int maxGCD = 0;

  for (int i = 0; i < INPUT.length - 1; i++) {
    int a = min(INPUT[i + 0], INPUT[i + 1]);
    int b = max(INPUT[i + 0], INPUT[i + 1]);
    int gcd = Euclid.gcd(a, b);

    if (gcd > maxGCD && a != b && a != gcd && b != gcd) {
      maxGCD = gcd;
      maxA = a;
      maxB = b;
    }
  }

  float sA = map(maxA, 0, 0xff, 0, 9.0/10.0 * mpg.width);
  float sB = maxB * sA / maxA;
  float sGCD = maxGCD * sA / maxA;
  float sX = (mpg.width - sA) / 2.0;
  float sY = (mpg.height - sB) / 2.0;

  mpg.rect(sX, sY, sA, sB);
  mpg.rect(sX, sY, sA, sA);
  mpg.rect(sX, sY, sGCD, sGCD);

  mpg.endDraw();
}
