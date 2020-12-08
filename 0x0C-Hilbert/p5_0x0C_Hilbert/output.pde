void drawOutput(PGraphics mpg) {
  randomSeed(101010);

  float mX[] = { max(mpg.width, mpg.height) };
  float mY[] = { max(mpg.width, mpg.height) };
  int borderOffset = 2 * OUT_SCALE;
  int rness = 4 * OUT_SCALE;

  int N[][] = {
    { 16 },
    { 16 },
    { 16 },
    { 16, 16, 3, 16, 16, 16, 3, 3, 10, 10 }
  };

  mpg.beginDraw();
  mpg.stroke(200, 0, 0, 128);
  mpg.strokeWeight(OUT_SCALE);
  mpg.noFill();

  for (int ni = 0; ni < N.length; ni++) {
    for (int i = 0; i < INPUT.length; i++) {
      Hilbert.N = N[ni][INPUT[i] % N[ni].length];

      PVector xy0 = Hilbert.d2xy(INPUT[i]);
      PVector xy1 = Hilbert.d2xy((INPUT[i] + 1) % 256);

      float x0 = map(xy0.x, 0, Hilbert.N - 1, borderOffset, mX[i % mX.length] - borderOffset);
      float y0 = map(xy0.y, 0, Hilbert.N - 1, borderOffset, mY[i % mY.length] - borderOffset);
      float x1 = map(xy1.x, 0, Hilbert.N - 1, borderOffset, mX[i % mX.length] - borderOffset);
      float y1 = map(xy1.y, 0, Hilbert.N - 1, borderOffset, mY[i % mY.length] - borderOffset);

      mpg.bezier(x0, y0,
                 lerp(x0 + random(-rness, rness), x1 + random(-rness, rness), random(0, 1)), lerp(y0 + random(-rness, rness), y1 + random(-rness, rness), random(0, 1)),
                 lerp(x0 + random(-rness, rness), x1 + random(-rness, rness), random(0, 1)), lerp(y0 + random(-rness, rness), y1 + random(-rness, rness), random(0, 1)),
                 x1, y1);
    }
  }
  mpg.endDraw();
}
