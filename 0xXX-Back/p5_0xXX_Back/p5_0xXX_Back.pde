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
  static final public String nameEN = "";
  static final public String namePT = "";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}

void setup() {
  size(840, 840);
  mSetup();
  BLEED_HEIGHT = BLEED_WIDTH;
  if (BLEED_HEIGHT) OUTPUT_GRAPHICS_DIMENSIONS = OUTPUT_DIMENSIONS.copy().sub(0, 0, 0);
}

void draw() {
  mDraw();
}
