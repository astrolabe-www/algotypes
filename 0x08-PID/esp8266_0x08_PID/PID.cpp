#ifndef _PID_CLASS_
#define _PID_CLASS_

#include <vector>
#include <stdlib.h>

class PID {
  private:
    const float KP = 0.160;
    const float KI = 160.0;
    const float KD = 0.000160;

    float dt;
    float goal;

    float error_now = 0.0;
    float error_previous = 0.0;
    float integral = 0.0;
    float derivative = 0.0;
    float input;
    std::vector<float> error;

    float step(float v) {
      error_now = goal - v;
      integral = integral + dt * error_now;
      derivative = (error_now - error_previous) / dt;
      error_previous = error_now;
      return (KP * error_now + KI * integral + KD * derivative);
    }

  public:
    PID(int* b, int b_length) {
      goal = (float)(b[b_length - 1]);
      dt = 1.0 / b_length;

      input = step(b[0]);
      error.push_back(goal - b[0]);

      for (int i = 1; i < b_length; i++) {
        input = step(0.5 * input + 0.5 * b[i]);
        error.push_back(error_now);
      }
    }

    int getError() {
      return (int)(abs(error_now));
    }

    const std::vector<float>* getErrors() {
      return &error;
    }
};

#endif
