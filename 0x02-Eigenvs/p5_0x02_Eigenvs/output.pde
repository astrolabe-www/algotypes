import java.util.Arrays;

void drawOutput(PGraphics mpg) {
  float[] out = A.page_rank().value;
  Arrays.sort(out);

  mpg.beginDraw();

  mpg.ellipseMode(CORNER);
  mpg.stroke(COLOR_RED, 0, 0, 24);
  mpg.strokeWeight(OUT_SCALE);
  mpg.fill(COLOR_RED, 0, 0, 10);

  for (int i = out.length - 1; i >= 0; i--) {
    float h = 32.0 * out[i] * mpg.height;
    mpg.ellipse(mpg.width / 2.0 - h / 2.0, mpg.height / 4.0 - OUT_SCALE * i, h, h);
  }
  mpg.endDraw();
}
