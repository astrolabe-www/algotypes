// based on:
// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
// http://rosettacode.org/wiki/Convex_hull

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0xZY";
  static final public String name = "Convex Hull";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  mSetup();
}

void draw() {
  mDraw();
}
