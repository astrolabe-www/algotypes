void drawOutput(PGraphics mpg) {
  int[] output = Quick.sort(INPUT);

  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(COLOR_RED, 0, 0, 8);
  mpg.fill(COLOR_RED, 0, 0, 32);
  mpg.strokeWeight(OUT_SCALE);

  for (int i = 0; i < output.length; i += 4) {
    float x = map(output[i+0], 0, 256, 0, mpg.width);
    float y = map(output[i+1], 0, 256, 0, mpg.height);
    float w = map(output[i+2], 0, 256, mpg.width/32, mpg.width/6);
    float h = map(output[i+3], 0, 256, mpg.height/32, mpg.height/6);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}
