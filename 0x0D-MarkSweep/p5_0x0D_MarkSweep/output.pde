void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.stroke(0, 128);
  mpg.strokeWeight(OUT_SCALE / 2);
  mpg.fill(255, 0, 0, 20);

  for (int i = 0; i < INPUT.length; i++) {
    if(mVM.step(INPUT[i])) mVM.markSweep();
  }

  mpg.endDraw();
}
