// Based on:
// https://en.wikipedia.org/wiki/Binary_tree
// https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
// https://en.wikipedia.org/wiki/Splay_tree
// https://en.wikipedia.org/wiki/Red–black_tree

// input
static final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

Tree mTree;
Tree mSplayTree;

void setup() {
  size(469, 804);
  noLoop();
}

void draw() {
  initInput();
  mTree = new Tree();
  mSplayTree = new SplayTree();


  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    mTree.insert(new Node(INPUT_NOISE[i]));
    mSplayTree.insert(new Node(INPUT_NOISE[i]));
  }

  print(mTree);
  println("\n -------- SPLAY -------- \n");
  print(mSplayTree);

  background(255);
}
