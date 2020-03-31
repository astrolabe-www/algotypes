void drawInput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < INPUT.length; i += 4) {
    float x = map(INPUT[i+0], 0, 256, 0, mpg.width);
    float y = map(INPUT[i+1], 0, 256, 0, mpg.height);
    float w = map(INPUT[i+2], 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT[i+3], 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  final boolean DEBUGMAZE = false;

  float w = max(float(mpg.width) / mMaze.size, float(mpg.height) / mMaze.size);
  float h = w;

  mpg.beginDraw();

  mpg.rectMode(CORNER);
  mpg.fill(200, 0, 0, 64);
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

  randomSeed(101010);

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

void drawBorders(PGraphics mpg, int bwidth) {
  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.stroke(255);
  mpg.fill(255);
  mpg.rect(0, 0, mpg.width, bwidth);
  mpg.rect(0, mpg.height - bwidth, mpg.width, bwidth);
  mpg.rect(0, 0, bwidth, mpg.height);
  mpg.rect(mpg.width - bwidth, 0, bwidth, mpg.height);

  mpg.noStroke();
  mpg.textFont(mFont);
  mpg.textSize(OUT_SCALE * FONT_SIZE);
  mpg.rectMode(CENTER);
  mpg.textAlign(CENTER, CENTER);
  mpg.fill(255);
  mpg.rect(mpg.width/2, bwidth, 1.111 * mpg.textWidth(Card.number), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.number, mpg.width/2, OUT_SCALE * FONT_SIZE / 2);

  mpg.fill(255);
  mpg.rect(mpg.width/2, mpg.height - bwidth, 1.111 * mpg.textWidth(Card.name), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.name, mpg.width/2, mpg.height - OUT_SCALE * 32);

  mpg.rectMode(CORNER);
  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(1);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.endDraw();
}
