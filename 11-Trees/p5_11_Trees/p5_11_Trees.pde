// Based on:
// https://en.wikipedia.org/wiki/Binary_tree
// https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
// https://en.wikipedia.org/wiki/Splay_tree

// input
int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
  }
}

Tree mTree;
Tree mSplayTree;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  mTree = new Tree();
  mSplayTree = new SplayTree();


  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    mTree.insert(new Node(INPUT_FRAMES[i]));
    mSplayTree.insert(new Node(INPUT_FRAMES[i]));
  }

  print(mTree);
  println("\n -------- SPLAY -------- \n");
  print(mSplayTree);

  background(255);

  drawInputFrames();
  drawOutput();
  drawBorders(10);
}
