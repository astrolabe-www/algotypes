#ifndef _POINT_CLASS_
#define _POINT_CLASS_

class Point {
  public:
    int x;
    int y ;

    Point(int x_, int y_) {
      x = x_;
      y = y_;
    }

    static bool ccw(Point a, Point b, Point c) {
      int area = ((b.x - a.x) * (c.y - a.y)) - ((b.y - a.y) * (c.x - a.x));
      return (area > 0);
    }

    static bool compare(Point a, Point b) {
      return ((a.x == b.x) ? (a.y < b.y) : (a.x < b.x));
    }
};

#endif
