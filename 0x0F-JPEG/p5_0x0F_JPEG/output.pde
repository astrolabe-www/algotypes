void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.strokeWeight(0.0);

  int[][] mjpeg = mJFIF.jpeg();
  int[][] mluminance = mJFIF.luminance();

  float w = float(mpg.width) / mJFIF.luminance[0].length;
  float h = float(mpg.height) / mJFIF.luminance.length;

  float minDiff = (mjpeg[0][0] - mluminance[0][0]);
  float maxDiff = (mjpeg[0][0] - mluminance[0][0]);

  for (int y = 0; y < mjpeg.length; y++) {
    for (int x = 0; x < mjpeg[y].length; x++) {
      float thisDiff = mjpeg[y][x] - mluminance[y][x];
      if (thisDiff > maxDiff) maxDiff = thisDiff;
      if (thisDiff < minDiff) minDiff = thisDiff;
    }
  }

  for (int y = 0; y < mjpeg.length; y++) {
    for (int x = 0; x < mjpeg[y].length; x++) {
      int red = (int)map((mjpeg[y][x] - mluminance[y][x]), minDiff, maxDiff, 0, 255);
      mpg.fill(red, 0, 0, (mjpeg[y][x] - mluminance[y][x]));
      mpg.stroke(red, 0, 0, (mjpeg[y][x] - mluminance[y][x]));
      mpg.rect(w*x, h*y, w, h);
    }
  }
  mpg.endDraw();
}
