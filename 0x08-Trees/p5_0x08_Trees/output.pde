void drawOutput(PGraphics mpg) {
  randomSeed(1212);
  for (int i = 0; i < 100; i++) {
    noiseSeed((long)(random(123456789)));
    mpg.beginDraw();
    mpg.stroke(COLOR_RED, 0, 0, 32);
    mpg.strokeWeight(OUT_SCALE);
    mpg.fill(COLOR_RED, 0, 0, 16);
    mpg.endDraw();
    //mSplayTree.draw(mpg);
    mTree.draw(mpg);
  }
}
