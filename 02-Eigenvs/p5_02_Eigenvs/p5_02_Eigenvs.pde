// Based on Power Iteration and QR decomposition
// https://en.wikipedia.org/wiki/Power_iteration
// https://en.wikipedia.org/wiki/QR_decomposition
// https://en.wikipedia.org/wiki/QR_algorithm

// input
static final int INPUT_SIZE = 1024;
int[] INPUT = new int[INPUT_SIZE];

void initInput() {
  for (int i=0; i < INPUT_SIZE; i++) {
    INPUT[i] = int(0xff * noise(i, frameCount));
  }
}

SquareMatrix A;

void setup() {
  size(469, 804);
  noLoop();
}


void draw() {
  initInput();

  A = new SquareMatrix(INPUT);
  A = new SquareMatrix(new int[]{5,5, 2,8});
  //A = new SquareMatrix(new int[]{6,-1, 2,3});
  //A = new SquareMatrix(new int[]{3,2,4, 2,0,2, 4,2,3});
  //A = new SquareMatrix(new int[]{12,-51,4, 6,167,-68, -4,24,-41});

  println(A.power_iteration());
  println(A.QR());

  background(255);
}
