// Based on Power Iteration and QR decomposition
// https://en.wikipedia.org/wiki/Power_iteration
// https://en.wikipedia.org/wiki/QR_decomposition
// https://en.wikipedia.org/wiki/QR_algorithm
// https://en.wikipedia.org/wiki/PageRank

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x02";
  static final public String name = "PageRank";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

SquareMatrix A;

void setup() {
  size(804, 804);
  mSetup();
  A = new SquareMatrix(INPUT);
}

void draw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUT_SCALE * OUTPUT_DIMENSIONS.x), int(OUT_SCALE * OUTPUT_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawOutput(mpg);
  drawBorders(mpg, BORDER_WIDTH);

  if (OUTPUT != Output.SCREEN) {
    mpg.save(Card.filename + ".png");
    mpg.save(Card.filename + ".jpg");
    exit();
  }

  pushMatrix();
  translate(width/ 2, height / 2);
  scale(float(height) / float(mpg.height));
  imageMode(CENTER);
  image(mpg, 0, 0);
  imageMode(CORNER);
  popMatrix();
}
