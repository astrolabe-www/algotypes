void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.strokeWeight(OUT_SCALE);
  mpg.stroke(COLOR_RED, 0, 0, 72);
  mpg.fill(0, 0, 0, 5);

  for (int i = 0; i < INPUT.length / 4; i += 4) {
    float x = map(INPUT[i+0], 0, 256, 0, mpg.width);
    float y = map(INPUT[i+1], 0, 256, 0, mpg.height);
    float w = map(INPUT[i+2], 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT[i+3], 0, 256, mpg.height/20, mpg.height/4);

    mpg.rect(x, y, w, h);
    mpg.rect(mpg.width - x, mpg.height - y, w, h);
    mpg.rect(mpg.width - x, y, w, h);
    mpg.rect(x, mpg.height - y, w, h);
  }
  mpg.endDraw();
}
