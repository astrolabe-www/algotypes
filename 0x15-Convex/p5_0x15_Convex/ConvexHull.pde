import java.util.Arrays;
import java.util.Comparator;

public static class Convex {
  public static Point[] Hull(Point[] in) {
    if (in.length < 3) return new Point[0];

    int n = in.length;

    Point[] LU = new Point[2 * n];
    for (int p = 0; p < LU.length; p++) LU[p] = new Point(0, 0);

    Arrays.sort(in, new Comparator<Point>() {
      @Override
      public int compare(Point a, Point b) {
        return (int) Math.signum((a.x == b.x) ? (a.y - b.y) : (a.x - b.x));
      }
    });

    int head = 0;

    for (int i = 0; i < n; i++) {
      while (head >= 2 && !Point.ccw(LU[head - 2], LU[head - 1], in[i])) head--;
      LU[head++] = in[i];
    }

    for (int i = n - 2, t = head + 1; i >= 0; i--) {
      while (head >= t && !Point.ccw(LU[head - 2], LU[head - 1], in[i])) head--;
      LU[head++] = in[i];
    }

    head = max(1, head);
    Point[] out = new Point[head - 1];
    for (int i = 0; i < out.length; i++) out[i] = LU[i];

    return out;
  }
}

public static class Point {
  public float x;
  public float y ;

  public Point(float x_, float y_) {
    x = x_;
    y = y_;
  }

  public static boolean ccw(Point a, Point b, Point c) {
    float area = ((b.x - a.x) * (c.y - a.y)) - ((b.y - a.y) * (c.x - a.x));
    return (area > 0);
  }
}
