// based on:
// https://en.wikipedia.org/wiki/Euclidean_algorithm

void initInput() {
  randomSeed(1010);
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
    INPUT[i] = ((INPUT[i] > 1) && (INPUT[i] < 0xff)) ? INPUT[i] : (int)random(1, 0xff);
  }
}

static class Card {
  static final public String number = "0x06";
  static final public String name = "Euclidean Greatest Common Divisor";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

void setup() {
  size(840, 840);
  mSetup();
}

void draw() {
  mDraw();
}
