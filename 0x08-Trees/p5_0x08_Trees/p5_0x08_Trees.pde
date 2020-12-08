// Based on:
// https://en.wikipedia.org/wiki/Binary_tree
// https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
// https://en.wikipedia.org/wiki/Splay_tree

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x08";
  static final public String name = "Splay Trees";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Tree mTree;
Tree mSplayTree;

void setup() {
  size(840, 840);
  mSetup();
  mTree = new Tree();
  mSplayTree = new SplayTree();
  for (int i = 0; i < INPUT.length; i++) {
    mTree.insert(new Node(INPUT[i]));
    mSplayTree.insert(new Node(INPUT[i]));
  }
}

void draw() {
  mDraw();
}
