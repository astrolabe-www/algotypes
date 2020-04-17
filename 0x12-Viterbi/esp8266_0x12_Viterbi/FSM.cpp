#ifndef _FSM_CLASS_
#define _FSM_CLASS_

class FSM {
  public:
    static const int NUMBER_STATES = 8;
    static const int NUMBER_STAGES = 8;

    float transitionProbability[NUMBER_STATES][NUMBER_STATES];

    float transition[NUMBER_STAGES][NUMBER_STATES][NUMBER_STATES];
    float P[NUMBER_STAGES][NUMBER_STATES];
    int F[NUMBER_STAGES][NUMBER_STATES];
    int out[NUMBER_STAGES];

  private:
    float flip(int from, int to) {
      int absDiff = (from > to) ? (from - to) : (to - from);
      if (absDiff < 1) return 0.8;
      else if (absDiff < 2) return 0.2;
      else if (absDiff < 3) return 0.01;
      else if (absDiff < 4) return 0.001;
      else return 0.00001;
    }

  public:
    FSM(int* in, int in_length) {
      float fromSum[NUMBER_STATES];

      for (int i = 0; i < NUMBER_STATES; i++) {
        for (int j = 0; j < NUMBER_STATES; j++) {
          transitionProbability[i][j] = 0.0;
        }
        fromSum[i] = 0.0;
      }

      for (int i = 1; i < in_length; i++) {
        int from = in[i - 1] % NUMBER_STATES;
        int to = in[i] % NUMBER_STATES;
        transitionProbability[from][to] += 1;
        fromSum[from] += 1;
      }

      for (int i = 0; i < NUMBER_STATES; i++) {
        for (int j = 0; j < NUMBER_STATES; j++) {
          transitionProbability[i][j] /= (fromSum[i] > 0) ? fromSum[i] : 1e9;
        }
      }
    }

    int* calculate(int* in) {
      for (int s = 0; s < NUMBER_STAGES; s++) {
        out[s] = 0;
        for (int from = 0; from < NUMBER_STATES; from++) {
          P[s][from] = 0.0;
          F[s][from] = -1;
          for (int to = 0; to < NUMBER_STATES; to++) {
            transition[s][from][to] = 0.0;
          }
        }
      }
      P[0][(in[0] / 16) % NUMBER_STATES] = 1.0;

      for (int s = 1; s < NUMBER_STAGES; s++) {
        for (int to = 0; to < NUMBER_STATES; to++) {
          float maxP = 0;
          int maxF = -1;
          for (int from = 0; from < NUMBER_STATES; from++) {
            if (P[s - 1][from] != 0) {
              float fromTo = P[s - 1][from] * transitionProbability[from][to] * flip(to, (in[s] / 16) % NUMBER_STATES);
              if (fromTo > maxP) {
                maxP = fromTo;
                maxF = from;
              }
              transition[s][from][to] = fromTo;
            }
          }
          P[s][to] = maxP;
          F[s][to] = maxF;
        }
      }

      float maxP = 0;
      int maxF = 0;
      for (int i = 0; i < NUMBER_STATES; i++) {
        if (P[NUMBER_STAGES - 1][i] > maxP) {
          maxP = P[NUMBER_STAGES - 1][i];
          maxF = i;
        }
      }

      out[NUMBER_STAGES - 1] = maxF;
      for (int i = NUMBER_STAGES - 2; i >= 0; i--) {
        out[i] = F[i + 1][out[i + 1]];
      }
      return out;
    }
};

#endif
