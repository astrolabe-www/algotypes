// Based on:
// https://en.wikipedia.org/wiki/Binary_tree
// https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
// https://en.wikipedia.org/wiki/Splay_tree

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
int[] INPUT;

void initInput() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FILENAME));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0B";
  static final public String name = "Splay Trees";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

Tree mTree;
Tree mSplayTree;

void setup() {
  size(469, 804);
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  noLoop();
  initInput();
  mTree = new Tree();
  mSplayTree = new SplayTree();
  for (int i = 0; i < INPUT.length; i++) {
    mTree.insert(new Node(INPUT[i]));
    mSplayTree.insert(new Node(INPUT[i]));
  }
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;
int FONT_SIZE = 32;
PFont mFont;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawInput(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save(Card.filename + ".png");
  // mpg.save(Card.filename + ".jpg");

  image(mpg, 0, 0, width, height);
}
