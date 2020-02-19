// Based on:
// https://en.wikipedia.org/wiki/Invertible_matrix
// https://en.wikipedia.org/wiki/Determinant
// https://en.wikipedia.org/wiki/LU_decomposition

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

LUPMatrix mLUPMatrix;

static class Card {
  static final public String number = "0x0C";
  static final public String name = "Matrix Inversion";
}

void setup() {
  size(469, 804, P3D);
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
  mLUPMatrix = new LUPMatrix(INPUT_FRAMES);

  println("///// MATRIX /////");
  println(mLUPMatrix);

  println("det = " + mLUPMatrix.determinant() + "\n");
  println(mLUPMatrix);

  println("///// INVERTED /////");
  println(mLUPMatrix.inverted());

  float SCALE = 3;
  float PITCH = PI * 0.42;
  float ROLL = -PI * 0.01;
  float YAW = PI * 0.09;
  float SLIDEX = 0.18;
  float SLIDEY = 0.55;

  background(255);

  PGraphics mpgI = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpgI.smooth(8);
  PGraphics mpgB = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpgB.smooth(8);
  PGraphics mpgO = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpgO.smooth(8);
  PGraphics mpgF = createGraphics(OUT_SCALE * width, OUT_SCALE * height, P3D);
  mpgF.smooth(8);

  drawInputFrames(mpgI);
  drawOutput(mpgO);
  drawBorders(mpgB, OUT_SCALE * BORDER_WIDTH);

  mpgF.beginDraw();
  mpgF.hint(DISABLE_DEPTH_MASK);
  mpgF.hint(DISABLE_DEPTH_TEST);
  mpgF.background(255);
  mpgF.image(mpgI, 0, 0, mpgF.width, mpgF.height);

  mpgF.pushMatrix();
  mpgF.translate(mpgF.width / 2, mpgF.height / 2);
  mpgF.rotateZ(ROLL);
  mpgF.rotateY(YAW);
  mpgF.rotateX(PITCH);
  mpgF.scale(SCALE, SCALE);
  mpgF.translate(-mpgF.width * SLIDEX, -mpgF.height * SLIDEY);
  mpgF.image(mpgO, 0, 0, mpgF.width, mpgF.height);
  mpgF.popMatrix();

  mpgF.image(mpgB, 0, 0, mpgF.width, mpgF.height);
  mpgF.endDraw();
  // mpgF.save("out.png");
  // mpgF.save("out.jpg");

  image(mpgF, 0, 0, width, height);
}
