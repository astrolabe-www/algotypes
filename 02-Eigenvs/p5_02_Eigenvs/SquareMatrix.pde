static class SquareMatrix {
  private float[][] value;
  private int size;

  public SquareMatrix(int s) {
    size = s;
    value = new float[size][size];

    for (int i = 0; i < size * size; i++) {
      value[i / size][i % size] = 0;
    }
  }

  public SquareMatrix(int[] input) {
    size = ceil(sqrt(input.length));
    value = new float[size][size];
    set(input);
  }

  public void set(int[] input) {
    for (int i = 0; i < size * size; i++) {
      value[i / size][i % size] = (i < input.length)?input[i]:0;
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

  public String toString() {
    String r = "";
    for (int i = 0; i < size; i++) {
      r += "[ ";
      for (int j = 0; j < size; j++) {
        r += value[i][j];
        r += (j < size - 1)?", ":" ]\n";
      }
    }
    return r;
  }
}
