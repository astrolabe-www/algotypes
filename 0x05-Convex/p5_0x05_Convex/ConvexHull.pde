public static class Convex {
  public static Point[] Hull(Point[] in) {
    Point[] out = new Point[in.length];
    for (int p = 0; p < out.length; p++) out[p] = new Point(0, 0);

    // TODO: find convex hull points

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
}
