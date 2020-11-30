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
  static final public String name = "Reaction-Diffusion";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Reaction mRD;

void setup() {
  size(804, 804);
  mSetup();
  mRD = new Reaction(INPUT);
}

void draw() {
  mDraw();
}
