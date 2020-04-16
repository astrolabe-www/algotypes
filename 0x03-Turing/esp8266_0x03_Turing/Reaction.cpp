#ifndef _REACTION_CLASS_
#define _REACTION_CLASS_

#include <math.h>
#include <vector>

struct Vec2 {
  float x;
  float y;
  Vec2(float x_, float y_) {
    x = x_;
    y = y_;
  }
};

class Reaction {
  private:
    const float DA = 1.0;
    const float DB = 0.5;
    const float FEED = 0.015;
    const float KILL = 0.015;
    const int STEPS = 8;

    float WEIGHT[3][3] = {
      {.05, .2, .05},
      {.2, -1, .2},
      {.05, .2, .05}
    };

    std::vector< std::vector<Vec2> > _AB[2];
    int pingpong = 0;
    int size;

    void step() {
      std::vector< std::vector<Vec2> > AB_n0 = _AB[pingpong];
      std::vector< std::vector<Vec2> > AB_n1 = _AB[1 - pingpong];
      pingpong = (pingpong + 1) % 2;

      for (int y = 1; y < size - 1; y++) {
        for (int x = 1; x < size - 1; x++) {
          float A = AB_n0[x][y].x;
          float B = AB_n0[x][y].y;
          float ABB = A * B * B;

          float avgA = 0;
          float avgB = 0;

          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              int nX = x + j;
              int nY = y + i;
              int wX = j + 1;
              int wY = i + 1;
              avgA += WEIGHT[wX][wY] * AB_n0[nX][nY].x;
              avgB += WEIGHT[wX][wY] * AB_n0[nX][nY].y;
            }
          }

          float A_ = A + (DA * avgA - ABB + FEED * (1.0 - A));
          float B_ = B + (DB * avgB + ABB - (KILL + FEED) * B);
          AB_n1[x][y].x = A_;
          AB_n1[x][y].y = B_;
        }
      }
    }

  public:
    Reaction(int* input, int input_length) {
      size = int(sqrt(input_length));

      for (int y = 0; y < size; y++) {
        std::vector<Vec2> r0;
        std::vector<Vec2> r1;
        for (int x = 0; x < size; x++) {
          int i = (y * size + x);
          float A = float(input[(2 * i + 0) % (input_length - 2)]) / 255.0;
          float B = float(input[(2 * i + 1) % (input_length - 1)]) / 255.0;
          r0.push_back(Vec2(A, B));
          r1.push_back(Vec2(A, B));
        }
        _AB[0].push_back(r0);
        _AB[1].push_back(r1);
      }

      for (int i = 0; i < STEPS; i++) {
        step();
      }
    }

    Vec2 AB(int i) {
      int x = (i / size) % size;
      int y = i % size;
      return _AB[pingpong][x][y];
    }
};

#endif
