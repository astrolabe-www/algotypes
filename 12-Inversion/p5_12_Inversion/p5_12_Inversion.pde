// Based on:
// https://en.wikipedia.org/wiki/Invertible_matrix
// https://en.wikipedia.org/wiki/Determinant
// https://en.wikipedia.org/wiki/LU_decomposition

// input
static final int INPUT_SIZE = 1024;
int[] INPUT = new int[INPUT_SIZE];

void initInput() {
  for (int i=0; i < INPUT_SIZE; i++) {
    INPUT[i] = int(0xff * noise(i, frameCount));
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
  mLUPMatrix = new LUPMatrix(INPUT);

  println(mLUPMatrix);
  println("det = " + mLUPMatrix.determinant() + "\n");
  println(mLUPMatrix);
  println("\nINVERTED\n");
  println(mLUPMatrix.inverted());

  background(255);
}
