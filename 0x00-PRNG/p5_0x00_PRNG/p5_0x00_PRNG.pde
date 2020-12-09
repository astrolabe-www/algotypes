// Based on RC4:
// https://en.wikipedia.org/wiki/RC4
// https://en.wikipedia.org/wiki/RC4#Key-scheduling_algorithm_(KSA)
// https://en.wikipedia.org/wiki/RC4#Pseudo-random_generation_algorithm_(PRGA)

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x00";
  static final public String name = "TEPseudo-Random Number Generator";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_");
}

PRNG mPRNG;

void setup() {
  size(840, 840);
  mSetup();
  mPRNG = new PRNG(INPUT);
}

void draw() {
  mDraw();
}
