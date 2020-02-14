static class SquareMatrix {
  static private final float PR_DAMPING = 0.85;
  private float[][] value;
  private int size;

  public SquareMatrix(int s) {
    size = s;
    value = new float[size][size];
    set(new int[0]);
  }

  public SquareMatrix(int[] input) {
    size = ceil(sqrt(input.length));
    value = new float[size][size];
    set(input);
  }

  public SquareMatrix(float[][] input) {
    size = min(input.length, input[0].length);
    value = input;
  }

  public void set(int[] input) {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        value[i][j] = ((i * size + j) < input.length) ? input[i * size + j] : 0;
      }
    }
  }

  public static SquareMatrix multiply(SquareMatrix A, SquareMatrix B) {
    int result_size = min(A.size, B.size);
    SquareMatrix result = new SquareMatrix(result_size);

    for (int i = 0; i < result_size; i++) {
      for (int j = 0; j < result_size; j++) {
        float sum = 0;
        for (int k = 0; k < result_size; k++) {
          sum += A.value[i][k] * B.value[k][j];
        }
        result.value[i][j] = sum;
      }
    }
    return result;
  }

  public SquareMatrix transpose() {
    SquareMatrix result = new SquareMatrix(size);
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        result.value[i][j] = value[j][i];
      }
    }
    return result;
  }

  private Vector get_column(int j) {
    Vector result = new Vector(size);
    for (int i = 0; i < size; i++) {
      result.value[i] = value[i][j];
    }
    return result;
  }

  private void set_column(int j, Vector v) {
    for (int i = 0; i < size; i++) {
      value[i][j] = v.value[i];
    }
  }

  public SquareMatrix Q() {
    SquareMatrix U = new SquareMatrix(size);

    for (int k = 0; k < size; k++) {
      Vector ak = get_column(k);

      Vector sum = new Vector(size);
      for (int j = 0; j < k; j++) {
        sum = Vector.add(sum, Vector.projection(U.get_column(j), ak));
      }

      U.set_column(k, Vector.subtract(ak, sum));
    }

    for (int j = 0; j < size; j++) {
      U.set_column(j, U.get_column(j).normalized());
    }

    return U;
  }

  public SquareMatrix R() {
    return SquareMatrix.multiply(Q().transpose(), this);
  }

  public SquareMatrix QR() {
    SquareMatrix Ak = new SquareMatrix(size);
    for (int i = 0; i < size * size; i++) {
      Ak.value[i / size][i % size] = value[i / size][i % size];
    }

    for (int iteration = 0; iteration < 64; iteration++) {
      Ak = SquareMatrix.multiply(Ak.R(), Ak.Q());
    }
    return Ak;
  }

  public Vector power_iteration() {
    int[] init = new int[size];

    for (int i = 0; i < init.length; i++) {
      init[i] = i;
    }

    Vector bk = new Vector(init);

    for (int iteration = 0; iteration < 32; iteration++) {
      Vector bk1 = Vector.multiply(this, bk);
      bk = bk1.normalized();
    }
    return bk;
  }

  public Vector page_rank() {
    return page_rank(PR_DAMPING);
  }

  public Vector page_rank(float d) {
    float[] _PR = new float[size];
    float[] _omdN = new float[size];
    float[][] _dM = new float[size][size];

    for (int j = 0; j < size; j++) {
      _PR[j] = 1.0 / size;
      _omdN[j] = (1 - d) / size;

      float Lj = 0.0;
      for (int i = 0; i < size; i++) {
        Lj += (i == j) ? 0.0 : value[i][j];
      }

      for (int i = 0; i < size; i++) {
        _dM[i][j] = (i == j) ? 0.0 : d * (value[i][j] / Lj);
      }
    }

    SquareMatrix dM = new SquareMatrix(_dM);
    Vector PR = new Vector(_PR);
    Vector omdN = new Vector(_omdN);

    for (int iteration = 0; iteration < 32; iteration++) {
      PR = Vector.add(Vector.multiply(dM, PR), omdN);
    }
    return PR;
  }

  public String toString() {
    String r = "";
    for (int i = 0; i < size; i++) {
      r += "[ ";
      for (int j = 0; j < size; j++) {
        r += String.format("%.4f", value[i][j]);
        r += (j < size - 1)?", ":" ]\n";
      }
    }
    return r;
  }
}
