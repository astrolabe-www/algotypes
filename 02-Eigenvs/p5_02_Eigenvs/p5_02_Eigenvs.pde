// Based on Power Iteration and QR decomposition
// https://en.wikipedia.org/wiki/Power_iteration
// https://en.wikipedia.org/wiki/QR_decomposition
// https://en.wikipedia.org/wiki/QR_algorithm
// https://en.wikipedia.org/wiki/PageRank

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
int[] INPUT;

void initInput() {
  byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x02";
  static final public String name = "Page Rank";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

SquareMatrix A;

void setup() {
  size(469, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
  A = new SquareMatrix(INPUT);
  println(A.page_rank());
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
