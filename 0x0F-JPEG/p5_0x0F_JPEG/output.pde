void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.strokeWeight(0.0);

  int[][] mjpeg = mJFIF.jpeg();
  int[][] mluminance = mJFIF.luminance();

  float w = float(mpg.width) / mJFIF.luminance[0].length;
  float h = float(mpg.height) / mJFIF.luminance.length;

  float minLuminance = mluminance[0][0];
  float maxLuminance = mluminance[0][0];

  float minJpeg = mjpeg[0][0];
  float maxJpeg = mjpeg[0][0];

  for (int y = 0; y < mjpeg.length; y++) {
    for (int x = 0; x < mjpeg[y].length; x++) {
      if (mluminance[y][x] > maxLuminance) maxLuminance = mluminance[y][x];
      if (mluminance[y][x] < minLuminance) minLuminance = mluminance[y][x];

      if (mjpeg[y][x] > maxJpeg) maxJpeg = mjpeg[y][x];
      if (mjpeg[y][x] < minJpeg) minJpeg = mjpeg[y][x];
    }
  }

  for (int y = 0; y < mjpeg.length; y++) {
    for (int x = 0; x < mjpeg[y].length; x++) {
      int luminanceNorm = int(map(mluminance[y][x], minLuminance, maxLuminance, 0, 255));
      int jpegNorm = int(map(mjpeg[y][x], minJpeg, maxJpeg, 0, 255) + 128) % 256;
      int alpha = luminanceNorm + jpegNorm;

      mpg.fill(COLOR_RED, 0, 0, alpha);
      mpg.stroke(COLOR_RED, 0, 0, alpha);
      mpg.rect(w * x, h * y, w, h);
    }
    mpg.rect(w * mjpeg[y].length, h * y, w, h);
  }

  int y = mjpeg.length;
  for (int x = 0; x < mjpeg[0].length; x++) {
    int luminanceNorm = int(map(mluminance[0][x], minLuminance, maxLuminance, 0, 255));
    int jpegNorm = int(map(mjpeg[0][x], minJpeg, maxJpeg, 0, 255) +128) % 256;
    int alpha = luminanceNorm + jpegNorm;

    mpg.fill(COLOR_RED, 0, 0, alpha);
    mpg.stroke(COLOR_RED, 0, 0, alpha);
    mpg.rect(w * x, h * y, w, h);
  }
  mpg.rect(w * mjpeg[0].length, h * y, w, h);

  mpg.endDraw();
}
