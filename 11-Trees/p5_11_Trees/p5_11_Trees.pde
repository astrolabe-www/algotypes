// Based on:
// https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
// https://en.wikipedia.org/wiki/Splay_tree
// https://en.wikipedia.org/wiki/Red–black_tree

// input
static final int INPUT_SIZE = 1024;
int[] INPUT = new int[INPUT_SIZE];

void initInput() {
  for (int i=0; i < INPUT_SIZE; i++) {
    INPUT[i] = int(0xff * noise(i, frameCount));
  }
}

Tree mTree;

void setup() {
  size(469, 804);
  noLoop();
}

void draw() {
  initInput();
  mTree = new RedBlackTree();

  for (int i = 0; i < INPUT.length; i++) {
    mTree.insert(new Node(INPUT[i]));
  }

  for (int i = 0; i < 300; i++) {
    Node found = mTree.find(i);
    if(found != null) println(i + " : " + found.count);
  }

  background(255);
}
