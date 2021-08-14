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
  static final public String nameEN = "Maze Search";
  static final public String namePT = "Travessia de Grafos e Labirintos";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}

Maze mMaze;

void setup() {
  size(840, 840);
  mSetup();
  mMaze = new Maze(INPUT);
}

void draw() {
  mDraw();
}
