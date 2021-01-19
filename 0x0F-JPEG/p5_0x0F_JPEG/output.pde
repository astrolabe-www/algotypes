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
      int alpha = int(map((mjpeg[y][x] - mluminance[y][x]), minDiff, maxDiff, 0, 255));
      mpg.fill(COLOR_RED, 0, 0, alpha);
      mpg.stroke(COLOR_RED, 0, 0, alpha);
      mpg.rect(w*x, h*y, w, h);
    }
    mpg.rect(w*mjpeg[y].length, h*y, w, h);
  }

  int y = mjpeg.length;
  for (int x = 0; x < mjpeg[0].length; x++) {
    int alpha = int(map((mjpeg[0][x] - mluminance[0][x]), minDiff, maxDiff, 0, 255));
    mpg.fill(COLOR_RED, 0, 0, alpha);
    mpg.stroke(COLOR_RED, 0, 0, alpha);
    mpg.rect(w*x, h*y, w, h);
  }
  mpg.rect(w*mjpeg[0].length, h*y, w, h);

  mpg.endDraw();
}
