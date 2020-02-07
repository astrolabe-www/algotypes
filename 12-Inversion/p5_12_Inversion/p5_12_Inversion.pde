// Based on:
// https://en.wikipedia.org/wiki/Invertible_matrix
// https://en.wikipedia.org/wiki/Determinant
// https://en.wikipedia.org/wiki/LU_decomposition

// input
static final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

LUPMatrix mLUPMatrix;

void setup() {
  size(469, 804);
  noLoop();
  noiseSeed(0);
}

void draw() {
  initInput();

  mLUPMatrix = new LUPMatrix(INPUT_NOISE);

  println(mLUPMatrix);

  println("det = " + mLUPMatrix.determinant() + "\n");
  println(mLUPMatrix);

  println("\nINVERTED\n");
  println(mLUPMatrix.inverted());

  println("\nIDENTITY\n");
  println(LUPMatrix.multiply(mLUPMatrix, mLUPMatrix.inverted()));

  background(255);
}
