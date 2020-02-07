// Based on Power Iteration and QR decomposition
// https://en.wikipedia.org/wiki/Power_iteration
// https://en.wikipedia.org/wiki/QR_decomposition
// https://en.wikipedia.org/wiki/QR_algorithm

// input
final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

SquareMatrix A;

void setup() {
  size(469, 804);
  noLoop();

  byte in[] = loadBytes(sketchPath("../../esp8266/frames_20200206-2351.raw"));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
  }
}


void draw() {
  initInput();

  A = new SquareMatrix(INPUT_FRAMES);
  //A = new SquareMatrix(new int[]{5,5, 2,8});
  //A = new SquareMatrix(new int[]{6,-1, 2,3});
  //A = new SquareMatrix(new int[]{3,2,4, 2,0,2, 4,2,3});
  //A = new SquareMatrix(new int[]{12,-51,4, 6,167,-68, -4,24,-41});

  println(A.power_iteration());
  println(A.QR());

  background(255);
}
