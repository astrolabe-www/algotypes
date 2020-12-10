// Based on:
// https://en.wikipedia.org/wiki/Invertible_matrix
// https://en.wikipedia.org/wiki/Determinant
// https://en.wikipedia.org/wiki/LU_decomposition

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0xZZ";
  static final public String name = "Matrix Inversion";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_");
}

LUPMatrix mLUPMatrix;

void setup() {
  size(804, 804, P3D);
  mSetup();
  mLUPMatrix = new LUPMatrix(INPUT);
}

void draw() {
  float PITCH = PI * 0.4;
  float ROLL = -PI * 0.05;
  float YAW = PI * 0.19;
  float SLIDEX = 0.333;
  float SLIDEY = 0.666;

  PVector SCALED_OUTPUT_DIMENSIONS = new PVector(OUT_SCALE * OUTPUT_DIMENSIONS.x, OUT_SCALE * OUTPUT_DIMENSIONS.y);

  PGraphics mpgB = createGraphics(int(SCALED_OUTPUT_DIMENSIONS.x), int(SCALED_OUTPUT_DIMENSIONS.y));
  PGraphics mpgO = createGraphics(int(SCALED_OUTPUT_DIMENSIONS.x), int(SCALED_OUTPUT_DIMENSIONS.y));
  PGraphics mpgF = createGraphics(int(SCALED_OUTPUT_DIMENSIONS.x), int(SCALED_OUTPUT_DIMENSIONS.y), P3D);

  mpgB.smooth(8);
  mpgO.smooth(8);
  mpgF.smooth(8);

  background(255);

  drawOutput(mpgO);
  drawBorders(mpgB);

  mpgF.beginDraw();
  mpgF.hint(DISABLE_DEPTH_MASK);
  mpgF.hint(DISABLE_DEPTH_TEST);
  mpgF.background(255);

  mpgF.pushMatrix();
  mpgF.translate(mpgF.width / 2, mpgF.height / 2);
  mpgF.rotateZ(ROLL);
  mpgF.rotateY(YAW);
  mpgF.rotateX(PITCH);
  mpgF.translate(-mpgF.width * SLIDEX, -mpgF.height * SLIDEY);
  mpgF.image(mpgO, 0, 0, mpgF.width, mpgF.height);
  mpgF.popMatrix();

  mpgF.image(mpgB, 0, 0, mpgF.width, mpgF.height);

  mpgF.save(Card.filename + ".png");
  if (args != null) {
    exit();
  }
  mpgF.endDraw();

  pushMatrix();
  translate(width/ 2, height / 2);
  scale(float(height) / float(mpgF.height));
  imageMode(CENTER);
  image(mpgF, 0, 0);
  imageMode(CORNER);
  popMatrix();
}
