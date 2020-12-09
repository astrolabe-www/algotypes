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
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_");
}

SquareMatrix A;

void setup() {
  size(840, 840);
  mSetup();
  A = new SquareMatrix(INPUT);
}

void draw() {
  mDraw();
}
