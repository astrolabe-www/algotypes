// based on:
// https://rosettacode.org/wiki/Sorting_algorithms/Quicksort

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x04";
  static final public String name = "Quicksort";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  mSetup();
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
