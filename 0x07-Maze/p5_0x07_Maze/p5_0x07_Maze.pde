// based on:
// https://en.wikipedia.org/wiki/Maze_generation_algorithm
// https://en.wikipedia.org/wiki/Breadth-first_search

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x07";
  static final public String name = "Maze Search";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Maze mMaze;

void setup() {
  size(804, 804);
  mSetup();
  mMaze = new Maze(INPUT);
}

void draw() {
  mDraw();
}
