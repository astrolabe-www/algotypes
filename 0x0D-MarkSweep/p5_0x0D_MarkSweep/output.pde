void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.stroke(0, 128);
  mpg.strokeWeight(OUT_SCALE / 2);
  mpg.fill(255, 0, 0, 20);

  for (int i = 0; i < INPUT.length; i++) {
    byte[] preMS = mVM.step(INPUT[i]);

    if(mVM.needsMarkSweep()) {
      // draw preMS
      byte[] postMS = mVM.markSweep();
      // draw postMS
    }
  }

  mpg.endDraw();
}
