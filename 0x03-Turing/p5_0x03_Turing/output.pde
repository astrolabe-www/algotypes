void drawOutput(PGraphics mpg) {
  mpg.beginDraw();
  mpg.strokeWeight(0);

  PVector[][] mAB = mRD.AB;
  int mSize = mRD.size;

  float w = float(mpg.width) / (mSize - 2);
  float h = float(mpg.height) / (mSize - 2);

  float drawDimesion = max(w, h);

  for (int y = 1; y < mSize - 1; y++) {
    for (int x = 1; x < mSize - 1; x++) {
      float redX = min(mAB[x][y].x * COLOR_RED, COLOR_RED);
      float redY = min(mAB[x][y].y * COLOR_RED, COLOR_RED);

      mpg.fill(redX, 0, 0, mAB[x][y].x * 32);
      mpg.stroke(redX, 0, 0, mAB[x][y].x * 32);
      mpg.rect(x * drawDimesion, y * drawDimesion, drawDimesion, drawDimesion);

      //mpg.fill(redY, 0, 0, mAB[x][y].y * 8);
      //mpg.stroke(redY, 0, 0, mAB[x][y].y * 8);
      //mpg.rect(x * drawDimesion, y * drawDimesion, drawDimesion, drawDimesion);
    }
  }

  mpg.endDraw();
}
