// Based on:
// https://en.wikipedia.org/wiki/CORDIC

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x11";
  static final public String name = "CORDIC";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  mSetup();
}

void draw() {
  mDraw();
}
