class Reaction {
  private final float DA = 1.0;
  private final float DB = 0.5;
  private final float FEED = 0.055;
  private final float KILL = 0.066;
  private final int STEPS = 24;
  
  private final float WEIGHT[][] = {
    {.05, .2, .05}, 
    {.2, -1, .2}, 
    {.05, .2, .05}
  };

  private PVector[][] AB;
  private int size;

  public Reaction(int[] input) {
    size = floor(sqrt(input.length / 2.0));
    AB = new PVector[size][size];

    for (int i = 0; i < (input.length / 2); i++) {
      float A = map(input[(2 * i + 0) % input.length], 0, 255, 0, 1.0);
      float B = map(input[(2 * i + 1) % input.length], 0, 255, 0, 1.0);

      AB[(i / size) % size][i % size] = new PVector(A, B);
    }

    for (int i = 0; i < STEPS; i++) {
      step();
    }
  }

  private void step() {
    PVector[][] AB_ = new PVector[size][size];

    for (int y = 1; y < size - 1; y++) {
      for (int x = 1; x < size - 1; x++) {
        float A = AB[x][y].x; 
        float B = AB[x][y].y;
        float ABB = A * B * B;

        float avgA = 0;
        float avgB = 0;

        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            int nX = x + j;
            int nY = y + i;
            int wX = j + 1;
            int wY = i + 1;
            avgA += WEIGHT[wX][wY] * AB[nX][nY].x;
            avgB += WEIGHT[wX][wY] * AB[nX][nY].y;
          }
        }

        float A_ = A + (DA * avgA - ABB + FEED * (1.0 - A));
        float B_ = B + (DB * avgB + ABB - (KILL + FEED) * B);
        AB_[x][y] = new PVector(A_, B_);
      }
    }

    for (int y = 1; y < size - 1; y++) {
      for (int x = 1; x < size - 1; x++) {
        AB[x][y].set(min(AB_[x][y].x, 2.0), min(AB_[x][y].y, 2.0));
      }
    }
  }

  public void draw(PGraphics mpg) {
    float w = float(mpg.width) / (size - 2);
    float h = float(mpg.height) / (size - 2);

    mpg.beginDraw();
    mpg.noStroke();

    for (int y = 1; y < size - 1; y++) {
      for (int x = 1; x < size - 1; x++) { 
        mpg.fill(AB[x][y].x * 255, 0, 0, AB[x][y].x * 32);
        mpg.rect(x * w, y * h, w, h);
      }
    }
    mpg.endDraw();
  }
}
