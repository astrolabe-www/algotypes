//
//

void initInput() {
  byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "";
  static final public String name = "";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_");
}

void setup() {
  size(840, 840);
  mSetup();
}

void draw() {
  mDraw();
}
