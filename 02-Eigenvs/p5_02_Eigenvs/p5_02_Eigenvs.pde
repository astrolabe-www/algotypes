// Based on Power Iteration and QR decomposition
// https://en.wikipedia.org/wiki/Power_iteration
// https://en.wikipedia.org/wiki/QR_decomposition
// https://en.wikipedia.org/wiki/QR_algorithm
// https://en.wikipedia.org/wiki/PageRank

// input
int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
  }
}

SquareMatrix A;
final int BORDER_WIDTH = 10;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  A = new SquareMatrix(INPUT_FRAMES);
  //A = new SquareMatrix(new int[]{3,2,4, 2,0,2, 4,2,3});
  //A = new SquareMatrix(new int[]{12,-51,4, 6,167,-68, -4,24,-41});

  //println("///// Power /////");
  //println(A.power_iteration());
  //println("///// QR /////");
  //println(A.QR());
  println("///// PageRank /////");
  println(A.page_rank());

  background(255);

  drawInputFrames();
  drawOutput(BORDER_WIDTH);
  drawBorders(BORDER_WIDTH);
}
