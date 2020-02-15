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

void setup() {
  size(469, 804, P3D);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  mLUPMatrix = new LUPMatrix(INPUT_FRAMES);

  println("///// MATRIX /////");
  println(mLUPMatrix);

  println("det = " + mLUPMatrix.determinant() + "\n");
  println(mLUPMatrix);

  println("///// INVERTED /////");
  println(mLUPMatrix.inverted());

  background(255);

  hint(DISABLE_DEPTH_MASK);
  hint(DISABLE_DEPTH_TEST);

  float SCALE = 3;
  float PITCH = PI * 0.42;
  float ROLL = -PI * 0.01;
  float YAW = PI * 0.09;
  float SLIDEX = 0.18;
  float SLIDEY = 0.55;

  image(drawInputFramesToGraphics(), 0, 0);

  pushMatrix();
  translate(width / 2, height / 2);
  rotateZ(ROLL);
  rotateY(YAW);
  rotateX(PITCH);
  scale(SCALE, SCALE);
  translate(-width * SLIDEX, -height * SLIDEY);
  image(drawOutputToGraphics(), 0, 0);
  popMatrix();

  drawBorders(10);
}
