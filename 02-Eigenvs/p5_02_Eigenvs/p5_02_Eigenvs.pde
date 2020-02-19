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

static class Card {
  static final public String number = "0x02";
  static final public String name = "Page Rank";
}

void setup() {
  size(469, 804);
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  noLoop();
  initInputNoise();
  initInputFrames();
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;
int FONT_SIZE = 32;
PFont mFont;

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

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(4);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawInputFrames(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save("out.png");
  // mpg.save("out.jpg");

  image(mpg, 0, 0, width, height);
}
