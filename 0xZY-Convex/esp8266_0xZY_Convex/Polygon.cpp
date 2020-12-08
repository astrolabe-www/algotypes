#ifndef _CONVEXHULL_CLASS_
#define _CONVEXHULL_CLASS_

#include "Point.cpp"
#include <algorithm>
#include <vector>

class Polygon {
  private:
    std::vector<Point> _polygon;
    std::vector<Point> _convexHull;

  public:
    Polygon (int* input, int input_length) {
      for (int i = 0; i < input_length / 2; i++) {
        _polygon.push_back(Point(input[2 * i + 0], input[2 * i + 1]));
        _convexHull.push_back(Point(input[2 * i + 0], input[2 * i + 1]));
      }
    }

    std::vector<Point>& convexHull() {
      int n = _polygon.size();
      int head = 0;

      if (n < 3) return _convexHull;

      std::vector<Point> LU;
      for (int p = 0; p < 2 * n; p++) {
        LU.push_back(Point(0, 0));
      }

      std::sort(_polygon.begin(), _polygon.end(), Point::compare);

      for (int i = 0; i < n; i++) {
        while (head >= 2 && !Point::ccw(LU[head - 2], LU[head - 1], _polygon[i])) head--;
        LU[head].x = _polygon[i].x;
        LU[head].y = _polygon[i].y;
        head++;
      }

      for (int i = n - 2, t = head + 1; i >= 0; i--) {
        while (head >= t && !Point::ccw(LU[head - 2], LU[head - 1], _polygon[i])) head--;
        LU[head].x = _polygon[i].x;
        LU[head].y = _polygon[i].y;
        head++;
      }

      head = (head > 1) ? head : 1;
      _convexHull.clear();
      for (int i = 0; i < head - 1; i++) {
        _convexHull.push_back(LU[i]);
      }
      return _convexHull;
    }
};

#endif
