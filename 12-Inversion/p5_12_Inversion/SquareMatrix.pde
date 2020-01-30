static class LUPMatrix {
  private float[][] value;
  private float[][] LU;
  private int[] P;
  private int size;
  private boolean isDecomposed;

  public LUPMatrix(int[] input) {
    size = ceil(sqrt(input.length));
    value = new float[size][size];
    LU = new float[size][size];
    P = new int[size + 1];
    set(input);
  }

  public void set(int[] input) {
    for (int i = 0; i < size * size; i++) {
      value[i / size][i % size] = input[i % input.length];
      LU[i / size][i % size] = value[i / size][i % size] / 0x80;
    }

    for (int i = 0; i < P.length; i++) {
      P[i] = i;
    }

    isDecomposed = false;
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

  public float[][] invert() {
    float[][] inv = new float[size][size];

    if (!isDecomposed) decompose();
    // TODO

    return inv;
  }

  private float[][] decompose() {
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
    return LU;
  }

  public String toString() {
    String r = "";
    for (int i = 0; i < size; i++) {
      r += "[ ";
      for (int j = 0; j < size; j++) {
        r += (isDecomposed) ? LU[i][j] : value[i][j];
        r += (j < size - 1)?", ":" ]\n";
      }
    }
    return r;
  }
}
