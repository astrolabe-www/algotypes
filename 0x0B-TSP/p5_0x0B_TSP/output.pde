void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.stroke(COLOR_RED, 0, 0, 64);
  mpg.strokeWeight(OUT_SCALE);
  mpg.fill(COLOR_RED, 0, 0, 32);
  mpg.endDraw();
  mGreedy.drawCities(mpg);
  mAnnealing.drawCities(mpg);
}
