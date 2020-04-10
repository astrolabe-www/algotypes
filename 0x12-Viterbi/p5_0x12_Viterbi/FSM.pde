public class FSM {
  public static final int NUMBER_STATES = 16;
  public static final int MAX_STAGES = 8;
  public float[][] transitionProbability;

  public float[][][] transition;
  public float[][] P;
  public int[][] F;
  public int[] out;

  public FSM(int[] in) {
    transitionProbability = new float[NUMBER_STATES][NUMBER_STATES];
    float[] fromSum = new float[NUMBER_STATES];

    for (int i = 0; i < transitionProbability.length; i++) {
      for (int j = 0; j < transitionProbability[i].length; j++) {
        transitionProbability[i][j] = 0.0;
      }
      fromSum[i] = 0.0;
    }

    for (int i = 1; i < in.length; i++) {
      int from = in[i - 1] % NUMBER_STATES;
      int to = in[i] % NUMBER_STATES;
      transitionProbability[from][to] += 1;
      fromSum[from] += 1;
    }

    for (int i = 0; i < transitionProbability.length; i++) {
      for (int j = 0; j < transitionProbability[i].length; j++) {
        transitionProbability[i][j] /= (fromSum[i] > 0) ? fromSum[i] : 1e9;
      }
    }
  }

  private float flip(int from, int to) {
    int absDiff = abs(from - to);
    return pow(2, (3.0 - 2 * absDiff))/ 10.0;
  }

  public int[] calculate(int[] in) {
    int stages = min(in.length, MAX_STAGES);
    out = new int[stages];

    transition = new float[stages][NUMBER_STATES][NUMBER_STATES];
    P = new float[stages][NUMBER_STATES];
    F = new int[stages][NUMBER_STATES];

    for (int s = 0; s < stages; s++) {
      for (int from = 0; from < P[s].length; from++) {
        P[s][from] = 0;
        F[s][from] = -1;
        for (int to = 0; to < transition[s][from].length; to++) {
          transition[s][from][to] = 0;
        }
      }
    }
    P[0][(in[0] >> 4) % NUMBER_STATES] = 1.0;

    for (int s = 1; s < stages; s++) {
      for (int to = 0; to < P[s].length; to++) {
        float maxP = 0;
        int maxF = -1;
        for (int from = 0; from < P[s-1].length; from++) {
          if (P[s-1][from] != 0) {
            float fromTo = P[s-1][from] * transitionProbability[from][to] * flip(to, (in[s] >> 4) % NUMBER_STATES);
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

    for (int s = 1; s < stages; s++) {
      float maxTP = 0;
      for (int to = 0; to < NUMBER_STATES; to++) {
        for (int from = 0; from < NUMBER_STATES; from++) {
          if (transition[s][from][to] > maxTP) maxTP =  transition[s][from][to];
        }
        for (int from = 0; from < NUMBER_STATES; from++) {
          transition[s][from][to] /= maxTP;
        }
      }
    }

    float maxP = 0;
    int maxF = 0;
    for (int i = 0; i < P[stages - 1].length; i++) {
      if (P[stages - 1][i] > maxP) {
        maxP = P[stages - 1][i];
        maxF = i;
      }
    }

    out[stages - 1] = maxF;
    for (int i = stages - 2; i >= 0; i--) {
      out[i] = F[i + 1][out[i + 1]];
    }
    return out;
  }
}
