void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.noFill();
  mpg.strokeWeight(OUT_SCALE);
  float alphaMultipplier = 2.0;
  int middleSections = 3;

  mFSM.calculate(INPUT);

  for (int s = 1; s < mFSM.F.length; s++) {
    for (int f = 0; f < mFSM.NUMBER_STATES; f++) {
      for (int t = 0; t < mFSM.NUMBER_STATES; t++) {
        float x0 = map(f, 0, mFSM.NUMBER_STATES - 1, 0, mpg.width);
        float y0 = map(s - 1, 0, mFSM.out.length - 1, 0, mpg.height);
        float x1 = map(t, 0, mFSM.NUMBER_STATES - 1, 0, mpg.width);
        float y1 = map(s, 0, mFSM.out.length - 1, 0, mpg.height);

        if ((s >= mFSM.F.length / 2 - middleSections / 2) && (s <= mFSM.F.length / 2 + middleSections / 2)) {
          float a = map(mFSM.transition[s][f][t], 0, 1, 0, alphaMultipplier * 80);
          mpg.stroke(COLOR_RED, 0, 0, a);
          mpg.line(x0, y0, x1, y1);

          a = map(mFSM.transitionProbability[f][t], 0, 1, 0, alphaMultipplier * 255);
          mpg.stroke(COLOR_RED, 0, 0, a);
          mpg.line(x0, y0, x1, y1);
        } else {
          float a = alphaMultipplier * 32;
          mpg.stroke(COLOR_RED, 0, 0, a);
          mpg.line(x0, y0, x1, y1);
        }
      }
    }
  }

  mpg.endDraw();
}
