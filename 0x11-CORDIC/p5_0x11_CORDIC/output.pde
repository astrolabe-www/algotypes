void drawOutput(PGraphics mpg) {
  float R = mpg.width / 1.9;

  mpg.beginDraw();
  mpg.fill(COLOR_RED, 0, 0, 32);
  mpg.stroke(COLOR_RED, 0, 0, 96);
  mpg.strokeWeight(OUT_SCALE);

  mpg.push();
  mpg.translate(mpg.width / 2.0, mpg.height / 2.0);

  mpg.beginShape();
  for (int i = 0; i < INPUT.length; i++) {
    float B = TWO_PI * i / INPUT.length;
    float[] c = CORDIC.cossin(B);
    float[] p = {cos(B), sin(B)};
    mpg.vertex(R * (p[0] - c[0]), R * (p[0] - c[1]));
  }
  mpg.endShape(CLOSE);

  mpg.beginShape();
  for (int i = 0; i < INPUT.length; i++) {
    float B = TWO_PI * i / INPUT.length;
    float[] c = CORDIC.cossin(B);
    float[] p = {cos(B), sin(B)};
    mpg.vertex(R * (p[0] - c[0]), R * (p[1] - c[0]));
  }
  mpg.endShape(CLOSE);

  mpg.beginShape();
  for (int i = 0; i < INPUT.length; i++) {
    float B = TWO_PI * i / INPUT.length;
    float rs = INPUT[i] / 255.0; 
    float[] c = CORDIC.cossin(B);
    float[] p = {cos(B), sin(B)};
    mpg.vertex(rs * R * (p[0] - c[0]), rs * R * (p[1] - c[1]));
  }
  mpg.endShape(CLOSE);

  mpg.pop();
  mpg.endDraw();
}
