void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.stroke(0, 128);
  mpg.strokeWeight(OUT_SCALE / 2);
  mpg.fill(255, 0, 0, 20);

  mpg.endDraw();
}
