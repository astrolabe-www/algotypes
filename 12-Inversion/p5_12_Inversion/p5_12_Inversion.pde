// Based on:
// https://en.wikipedia.org/wiki/Invertible_matrix
// https://en.wikipedia.org/wiki/Determinant
// https://en.wikipedia.org/wiki/LU_decomposition

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
int[] INPUT;

void initInput() {
  byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0C";
  static final public String name = "Matrix Inversion";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

LUPMatrix mLUPMatrix;

void setup() {
  size(469, 804, P3D);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
  mLUPMatrix = new LUPMatrix(INPUT);
  println(mLUPMatrix.inverted());
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;
int FONT_SIZE = 32;
PFont mFont;

void draw() {
  float SCALE = 3.0;
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

  drawInput(mpgI);
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
  // mpg.save(Card.filename + ".png");
  // mpg.save(Card.filename + ".jpg");

  image(mpgF, 0, 0, width, height);
}
