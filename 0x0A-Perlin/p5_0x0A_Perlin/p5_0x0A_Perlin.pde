// Based on:
// https://en.wikipedia.org/wiki/Perlin_noise

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0A";
  static final public String name = "Perlin Noise";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_");
}

Perlin mPerlin;

void setup() {
  size(840, 840);
  mSetup();
  mPerlin = new Perlin(INPUT);
}

void draw() {
  mDraw();
}
