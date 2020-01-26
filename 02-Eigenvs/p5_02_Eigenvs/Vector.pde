static class Vector {
  private float[] value;
  private int size;

  public Vector(int s) {
    size = s;
    value = new float[size];
    set(new int[0]);
  }

  public Vector(int[] input) {
    size = input.length;
    value = new float[size];
    set(input);
  }

  public void set(int[] input) {
    for (int i = 0; i < size; i++) {
      value[i] = (i < input.length)?input[i]:0;
    }
  }

  public static float inner_product(Vector v, Vector w) {
    float sum = 0;
    for (int i = 0; i < v.size; i++) {
      sum += v.value[i] * w.value[i];
    }
    return sum;
  }

  public static Vector projection(Vector u, Vector a) {
    Vector result = new Vector(u.size);

    float scaler =  Vector.inner_product(u, a) / Vector.inner_product(u, u);

    for (int i = 0; i < u.size; i++) {
      result.value[i] = scaler * u.value[i];
    }
    return result;
  }

  public static Vector add(Vector A, Vector B) {
    int result_size = min(A.size, B.size);
    Vector result = new Vector(result_size);
    for (int i = 0; i < result_size; i++) {
      result.value[i] = A.value[i] + B.value[i];
    }
    return result;
  }

  public static Vector subtract(Vector A, Vector B) {
    int result_size = min(A.size, B.size);
    Vector result = new Vector(result_size);
    for (int i = 0; i < result_size; i++) {
      result.value[i] = A.value[i] - B.value[i];
    }
    return result;
  }

  private float norm() {
    float norm_sum = 0;
    for (int i = 0; i < size; i++) {
      norm_sum += value[i] * value[i];
    }
    return sqrt(norm_sum);
  }

  public Vector normalized() {
    Vector result = new Vector(size);
    float norm = norm();
    for (int i = 0; i < size; i++) {
      result.value[i] = value[i] / norm;
    }
    return result;
  }

  public static Vector multiply(SquareMatrix A, Vector B) {
    int result_size = min(A.size, B.size);
    Vector result = new Vector(result_size);

    for (int i = 0; i < result_size; i++) {
      float sum = 0;
      for (int k = 0; k < result_size; k++) {
        sum += A.value[i][k] * B.value[k];
      }
      result.value[i] = sum;
    }
    return result;
  }

  public String toString() {
    String r = "[ ";
    for (int i = 0; i < size; i++) {
      r += value[i];
      r += (i < size - 1)?", ":" ]\n";
    }
    return r;
  }
}
