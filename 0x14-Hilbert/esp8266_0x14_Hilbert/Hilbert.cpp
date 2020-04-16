#ifndef _HILBERT_CLASS_
#define _HILBERT_CLASS_

struct Vec2 {
  int x;
  int y;
  Vec2(int x_, int y_) {
    x = x_;
    y = y_;
  }
};

class Hilbert {
  private:
    static const int N = 256;

    static Vec2 rot(int n, int x, int y, int rx, int ry) {
      if (ry == 0) {
        if (rx == 1) {
          x = (n - 1) - x;
          y = (n - 1) - y;
        }

        int t  = x;
        x = y;
        y = t;
      }
      return Vec2(x, y);
    }

  public:
    static Vec2 d2xy(int d) {
      int t = d;
      int x = 0;
      int y = 0;

      for (int s = 1; s < Hilbert::N; s *= 2) {
        int rx = 0x1 & (t / 2);
        int ry = 0x1 & (t ^ rx);

        Vec2 rd = Hilbert::rot(s, x, y, rx, ry);
        x = (int)(rd.x + (s * rx));
        y = (int)(rd.y + (s * ry));

        t /= 4;
      }

      return Vec2(x, y);
    }
};

#endif
