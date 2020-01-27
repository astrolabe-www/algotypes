class Perlin {
  private final int SIZE_OF_FIELD_DIMENSIONB = 4;
  private final int SIZE_OF_FIELD_DIMENSION = (1 << SIZE_OF_FIELD_DIMENSIONB);
  private final int SIZE_OF_FIELD_TWO_DIMENSION = SIZE_OF_FIELD_DIMENSION * SIZE_OF_FIELD_DIMENSION;
  private final int SIZE_OF_FIELD = SIZE_OF_FIELD_DIMENSION * SIZE_OF_FIELD_TWO_DIMENSION;
  private final int SIZE_OF_FIELD_MODULO = SIZE_OF_FIELD - 1;

  private final float[][] FIELD = new float[SIZE_OF_FIELD][3];

  public Perlin(int[] input) {
    for (int i = 0; i < FIELD.length; i++) {
      for (int d = 0; d < 3; d++) {
        FIELD[i][d] = input[((i*3)+d) % input.length] / 255.0f;
      }
    }
  }

  public float noise(float x, float y, float z) {
    return noise_naive(x, y, z);
  }
  public float noise(float x, float y) {
    return noise_naive(x, y, 0);
  }
  public float noise(float x) {
    return noise_naive(x, 0, 0);
  }

  private float noise_naive(float x, float y, float z) {
    if (x < 0) x = -x;
    if (y < 0) y = -y;
    if (z < 0) z = -z;

    int x0 = int(x);
    int y0 = int(y);
    int z0 = int(z);

    int x1 = x0 + 1;
    int y1 = y0 + 1;
    int z1 = z0 + 1;

    float wx = cos_lerp(x - int(x));
    float wy = cos_lerp(y - int(y));
    float wz = cos_lerp(z - int(z));

    float n0 = dotDistanceGradient(x0, y0, z0, x, y, z);
    float n1 = dotDistanceGradient(x1, y0, z0, x, y, z);
    float dx0 = lerp(n0, n1, wx);

    float n2 = dotDistanceGradient(x0, y1, z0, x, y, z);
    float n3 = dotDistanceGradient(x1, y1, z0, x, y, z);
    float dx1 = lerp(n2, n3, wx);

    float n4 = dotDistanceGradient(x0, y0, z1, x, y, z);
    float n5 = dotDistanceGradient(x1, y0, z1, x, y, z);
    float dx2 = lerp(n4, n5, wx);

    float n6 = dotDistanceGradient(x0, y1, z1, x, y, z);
    float n7 = dotDistanceGradient(x1, y1, z1, x, y, z);
    float dx3 = lerp(n6, n7, wx);

    float dy0 = lerp(dx0, dx1, wy);
    float dy1 = lerp(dx2, dx3, wy);

    float dz0 = lerp(dy0, dy1, wz);

    return dz0;
  }

  private float dotDistanceGradient(int x0, int y0, int z0, float x1, float y1, float z1) {
    int field_index = (x0 + y0 * SIZE_OF_FIELD_DIMENSION + z0 * SIZE_OF_FIELD_TWO_DIMENSION) & SIZE_OF_FIELD_MODULO;

    float dx = 1.0f - (x1 - x0);
    float dy = 1.0f - (y1 - y0);
    float dz = 1.0f - (z1 - z0);

    float gx = FIELD[field_index][0];
    float gy = FIELD[field_index][1];
    float gz = FIELD[field_index][2];

    float dot = (dx * gx + dy * gy + dz * gz);
    return 0.33333 * dot;
  }

  private float lerp(float a, float b, float w) {
    return a + w * (b - a);
  }

  private float cos_lerp(float i) {
    return 0.5f * (1.0f - cos(i * PI));
  }
}
