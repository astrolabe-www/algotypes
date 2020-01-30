public class JFIF {
  private final int[][] LUMINANCE_QUANTIZATION = new int[][] {
    {16, 11, 10, 16, 24, 40, 51, 61}, 
    {12, 12, 14, 19, 26, 28, 60, 55}, 
    {14, 13, 16, 24, 40, 57, 69, 56}, 
    {14, 17, 22, 29, 51, 87, 80, 62}, 
    {18, 22, 37, 56, 68, 109, 103, 77}, 
    {24, 35, 55, 64, 81, 104, 113, 92}, 
    {49, 64, 78, 87, 103, 121, 120, 101}, 
    {72, 92, 95, 98, 112, 100, 103, 99}
  };

  private final int BLOCK_DIMENSION = 8;

  private int size;
  private int[][] luminance;
  private int[][] jpegged;
  private boolean isJpegged;

  public JFIF(int[] input) {
    size = ceil(sqrt(input.length));
    luminance = new int[size][size];
    jpegged = new int[size][size];
    set(input);
  }

  public void set(int[] input) {
    for (int i = 0; i < size * size; i++) {
      luminance[i / size][i % size] = input[i % input.length];
    }
    isJpegged = false;
  }

  public int[][] luminance() {
    return luminance;
  }

  public int[][] jpeg() {
    if (isJpegged) return jpegged;

    for (int yb = 0; yb < size; yb += BLOCK_DIMENSION) {
      for (int xb = 0; xb < size; xb += BLOCK_DIMENSION) {
        int[][] block = new int[BLOCK_DIMENSION][BLOCK_DIMENSION];

        for (int p = 0; p < BLOCK_DIMENSION; p++) {
          arraycopy(luminance[yb + p], xb, block[p], 0, BLOCK_DIMENSION);
        }

        int[][] quanted = center_block(quantize_block(DCT_block(center_block(block, 128)), LUMINANCE_QUANTIZATION), -128);

        for (int p = 0; p < BLOCK_DIMENSION; p++) {
          arraycopy(quanted[p], 0, jpegged[yb + p], xb, BLOCK_DIMENSION);
        }
      }
    }

    isJpegged = true;
    return jpegged;
  }

  private int[][] center_block(int[][] p, int v) {
    for (int i = 0; i < BLOCK_DIMENSION; i++) {
      for (int j = 0; j < BLOCK_DIMENSION; j++) {
        p[i][j] = p[i][j] - v;
      }
    }
    return p;
  }

  private int[][] DCT_block(int[][] p) {
    int[][] g = new int[BLOCK_DIMENSION][BLOCK_DIMENSION];
    float SQRT_2_2 = sqrt(2.0) / 2.0;

    for (int v = 0; v < BLOCK_DIMENSION; v++) {
      float a_v = (v == 0) ? SQRT_2_2 : 1;

      for (int u = 0; u < BLOCK_DIMENSION; u++) {
        float a_u = (u == 0) ? SQRT_2_2 : 1;
        float sum = 0;

        for (int y = 0; y < BLOCK_DIMENSION; y++) {
          float cos_y = cos((2 * y + 1) * v * PI / 16f);
          for (int x = 0; x < BLOCK_DIMENSION; x++) {
            sum += p[y][x] * cos((2 * x + 1) * u * PI / 16f) * cos_y;
          }
        }
        g[v][u] = round(0.25 * a_v * a_u * sum);
      }
    }
    return g;
  }

  private int[][] quantize_block(int[][] p, int[][] q) {
    int[][] g = new int[BLOCK_DIMENSION][BLOCK_DIMENSION];

    for (int i = 0; i < BLOCK_DIMENSION; i++) {
      for (int j = 0; j < BLOCK_DIMENSION; j++) {
        g[i][j] = round(p[i][j] / q[i][j]);
      }
    }
    return g;
  }

  public String toString() {
    return toString(luminance);
  }

  private String toString(int[][] p) {
    String r = "";
    for (int i = 0; i < p.length; i++) {
      r += "[ ";
      for (int j = 0; j < p[i].length; j++) {
        r += p[i][j];
        r += (j < size - 1)?", ":" ]\n";
      }
    }
    return r;
  }
}
