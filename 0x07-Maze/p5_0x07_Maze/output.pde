void drawOutput(PGraphics mpg) {
  final boolean DEBUGMAZE = false;

  float w = max(float(mpg.width) / mMaze.size, float(mpg.height) / mMaze.size);
  float h = w;

  mpg.beginDraw();

  mpg.rectMode(CORNER);
  mpg.fill(COLOR_RED, 0, 0, 64);
  mpg.noStroke();
  mpg.strokeWeight(OUT_SCALE * 1);

  if (DEBUGMAZE) {
    for (int y = 0; y < mMaze.mGrid.length; y++) {
      for (int x = 0; x < mMaze.mGrid[y].length; x++) {
        if (mMaze.mGrid[y][x].wallH[0]) mpg.line((x + 0) * w, (y + 0) * h, (x + 0) * w, (y + 1) * h);
        if (mMaze.mGrid[y][x].wallH[2]) mpg.line((x + 1) * w, (y + 0) * h, (x + 1) * w, (y + 1) * h);
        if (mMaze.mGrid[y][x].wallV[0]) mpg.line((x + 0) * w, (y + 0) * h, (x + 1) * w, (y + 0) * h);
        if (mMaze.mGrid[y][x].wallV[2]) mpg.line((x + 0) * w, (y + 1) * h, (x + 1) * w, (y + 1) * h);
      }
    }
  }

  randomSeed(101);

  for (int p = 0; p < 70; p++) {
    Queue mQueue = new Queue();
    boolean[][] visited = new boolean[mMaze.mGrid.length][mMaze.mGrid[0].length];

    Cell c0 = mMaze.mGrid[int(random(0, mMaze.mGrid.length))][int(random(0, mMaze.mGrid[0].length))];
    visited[c0.y][c0.x] = true;
    mQueue.push(c0);

    while (!mQueue.isEmpty()) {
      Cell n = mQueue.pop();
      mpg.rect(n.x * w, n.y * h, w, h);

      if (n.v == c0.v && n.x != c0.x && n.y != c0.y) {
        mQueue.clear();
      } else {
        if (!n.wallH[0] && !visited[n.y][n.x - 1]) {
          visited[n.y][n.x - 1] = true;
          mQueue.push(mMaze.mGrid[n.y][n.x - 1]);
        }
        if (!n.wallH[2] && !visited[n.y][n.x + 1]) {
          visited[n.y][n.x + 1] = true;
          mQueue.push(mMaze.mGrid[n.y][n.x + 1]);
        }
        if (!n.wallV[0] && !visited[n.y - 1][n.x]) {
          visited[n.y - 1][n.x] = true;
          mQueue.push(mMaze.mGrid[n.y - 1][n.x]);
        }
        if (!n.wallV[2] && !visited[n.y + 1][n.x]) {
          visited[n.y + 1][n.x] = true;
          mQueue.push(mMaze.mGrid[n.y + 1][n.x]);
        }
      }
    }
  }

  mpg.endDraw();
}
