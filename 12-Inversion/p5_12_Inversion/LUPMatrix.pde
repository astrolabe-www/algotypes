static class LUPMatrix {
  private float[][] value;
  private float[][] eulav;
  private float[][] LU;
  private int[] P;
  private int size;
  private boolean isDecomposed;
  private boolean isInverted;

  public LUPMatrix(int[] input) {
    size = ceil(sqrt(input.length));
    value = new float[size][size];
    eulav = new float[size][size];
    LU = new float[size][size];
    P = new int[size + 1];
    set(input);
  }

  public LUPMatrix(float[][] input) {
    size = input[0].length;
    value = new float[size][size];
    eulav = new float[size][size];
    LU = new float[size][size];
    P = new int[size + 1];
    set(input);
  }

  public void set(int[] input) {
    for (int i = 0; i < size * size; i++) {
      value[i / size][i % size] = input[i % input.length];
      eulav[i / size][i % size] = input[i % input.length];
      LU[i / size][i % size] = input[i % input.length];
    }

    for (int i = 0; i < P.length; i++) {
      P[i] = i;
    }

    isDecomposed = false;
    isInverted = false;
  }

  public void set(float[][] input) {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        value[i][j] = input[i][j];
        eulav[i][j] = input[i][j];
        LU[i][j] = input[i][j];
      }
    }

    for (int i = 0; i < P.length; i++) {
      P[i] = i;
    }

    isDecomposed = false;
    isInverted = false;
  }

  public float determinant() {
    if (!isDecomposed) decompose();

    float det = 1;
    for (int i = 0; i < size; i ++) {
      det *= LU[i][i];
    }

    if ((P[size] - size) % 2 == 0) return det;
    else return -det;
  }

  public LUPMatrix inverted() {
    if (!isDecomposed) decompose();
    if (!isInverted) invert();
    return new LUPMatrix(eulav);
  }

  private void invert() {
    for (int j = 0; j < size; j++) {
      for (int i = 0; i < size; i++) {
        if (P[i] == j) eulav[i][j] = 1.0;
        else eulav[i][j] = 0.0;

        for (int k = 0; k < i; k++) {
          eulav[i][j] = eulav[i][j] - LU[i][k] * eulav[k][j];
        }
      }

      for (int i = size - 1; i >= 0; i--) {
        for (int k = i + 1; k < size; k++) {
          eulav[i][j] = eulav[i][j] - LU[i][k] * eulav[k][j];
        }
        eulav[i][j] = eulav[i][j] / LU[i][i];
      }
    }
    isInverted = true;
  }

  private void decompose() {
    for (int step = 0; step < size; step++) {
      float maxColVal = 0;
      int maxColValRow = step;

      for (int row = step; row < size; row++) {
        if (LU[row][step] > maxColVal) {
          maxColVal = LU[row][step];
          maxColValRow = row;
        }
      }

      // put col max value on diagonal
      if (maxColValRow != step) {
        int tp = P[step];
        P[step] = P[maxColValRow];
        P[maxColValRow] = tp;

        float[] tr = LU[step].clone();
        System.arraycopy(LU[maxColValRow], 0, LU[step], 0, LU[step].length);
        System.arraycopy(tr, 0, LU[maxColValRow], 0, LU[maxColValRow].length);

        P[size] += 1;
      }

      for (int row = step + 1; row < size; row++) {
        LU[row][step] = LU[row][step] / LU[step][step];

        for (int col = step + 1; col < size; col++) {
          LU[row][col] = LU[row][col] - LU[row][step] * LU[step][col];
        }
      }
    }

    isDecomposed = true;
  }

  public static LUPMatrix multiply(LUPMatrix A, LUPMatrix B) {
    int result_size = min(A.size, B.size);
    float[][] result = new float[result_size][result_size];

    for (int i = 0; i < result_size; i++) {
      for (int j = 0; j < result_size; j++) {
        float sum = 0;
        for (int k = 0; k < result_size; k++) {
          sum += A.value[i][k] * B.value[k][j];
        }
        result[i][j] = sum;
      }
    }
    return new LUPMatrix(result);
  }

  public String toString() {
    String r = "";
    for (int i = 0; i < size; i++) {
      r += "[ ";
      for (int j = 0; j < size; j++) {
        r += String.format("%.03f", (isDecomposed) ? LU[i][j] : value[i][j]);
        r += (j < size - 1)?", ":" ]\n";
      }
    }
    return r;
  }
}
