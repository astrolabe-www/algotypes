#ifndef _CORDIC_CLASS_
#define _CORDIC_CLASS_

struct Vec2 {
  float x;
  float y;
  Vec2(float x_, float y_) {
    x = x_;
    y = y_;
  }
};

class CORDIC {
  private:
    static const int ITERATIONS;
    static const float PI_;
    static const float ANGLES[];
    static const int ANGLES_LENGTH;
    static const float KS[];
    static const int KS_LENGTH;
    static const float K;

  public:
    static Vec2 cossin(float beta);
};

#endif
