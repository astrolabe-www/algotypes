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
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  mSetup();
}

void draw() {
  mDraw();
}
