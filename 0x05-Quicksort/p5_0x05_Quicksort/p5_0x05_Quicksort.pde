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
  static final public String number = "0x05";
  static final public String nameEN = "Quicksort";
  static final public String namePT = "Quicksort";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}

void setup() {
  size(840, 840);
  mSetup();
}

void draw() {
  mDraw();
}
