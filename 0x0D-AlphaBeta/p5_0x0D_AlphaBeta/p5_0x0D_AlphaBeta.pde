// based on:
// https://www.hackerearth.com/blog/developers/minimax-algorithm-alpha-beta-pruning/
// https://en.wikipedia.org/wiki/Alpha–beta_pruning

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0D";
  static final public String name = "Alpha-Beta Pruning";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Board mBoard;

void setup() {
  size(804, 804);
  mSetup();
  mBoard = new Board();
}

void draw() {
  mDraw();
}
