// Based on:
// http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.37.4165
// https://en.wikipedia.org/wiki/Hilbert_curve

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0C";
  static final public String nameEN = "Hilbert Curves";
  static final public String namePT = "Curva de Hilbert";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}


void setup() {
  size(840, 840);
  mSetup();
}

void draw() {
  mDraw();
}
