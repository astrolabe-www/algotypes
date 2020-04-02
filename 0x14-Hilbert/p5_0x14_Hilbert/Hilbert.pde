public static class Hilbert {
  public static int N = 16;

  public static PVector d2xy(int d) {
    int t = d;
    int x = 0;
    int y = 0;

    for (int s = 1; s < Hilbert.N; s *= 2) {
      int rx = 1 & (t / 2);
      int ry = 1 & (t ^ rx);

      PVector rd = Hilbert.rot(s, x, y, rx, ry);
      x = (int)(rd.x + (s * rx));
      y = (int)(rd.y + (s * ry));

      t /= 4;
    }

    return new PVector(x, y);
  }

  private static PVector rot(int n, int x, int y, int rx, int ry) {
    if (ry == 0) {
      if (rx == 1) {
        x = (n - 1) - x;
        y = (n - 1) - y;
      }

      int t  = x;
      x = y;
      y = t;
    }
    return new PVector(x, y);
  }
}
