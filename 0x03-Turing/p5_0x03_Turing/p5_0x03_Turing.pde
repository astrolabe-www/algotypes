// based on:
// http://karlsims.com/rd.html

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x03";
  static final public String nameEN = "Reaction-Diffusion";
  static final public String namePT = "Reação-Difusão";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}

Reaction mRD;

void setup() {
  size(840, 840);
  mSetup();
  mRD = new Reaction(INPUT);
}

void draw() {
  mDraw();
}
