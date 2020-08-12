// based on:
// https://www.hackerearth.com/blog/developers/minimax-algorithm-alpha-beta-pruning/
// https://en.wikipedia.org/wiki/Alpha–beta_pruning

enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

Output OUTPUT = Output.SCREEN;
PVector OUTPUT_DIMENSIONS = new PVector((OUTPUT != Output.TELEGRAM) ? 469 : 804, 804);

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
String INPUT_FILEPATH;
int[] INPUT;

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
  static final public String filename = number + "_" + name.replace(" ", "_");
}

Board mBoard;

void setup() {
  size(804, 804);
  noLoop();
  mFont = createFont("Montserrat-Thin", OUT_SCALE * FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME);
  initInput();
  mBoard = new Board();
}

int OUT_SCALE = (OUTPUT == Output.PRINT) ? 10 : 1;
int BORDER_WIDTH = 10;
int FONT_SIZE = 32;
PFont mFont;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUT_SCALE * OUTPUT_DIMENSIONS.x), int(OUT_SCALE * OUTPUT_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);

  if (OUTPUT != Output.SCREEN) {
    mpg.save(Card.filename + ".png");
    mpg.save(Card.filename + ".jpg");
    exit();
  }

  pushMatrix();
  translate(width/ 2, height / 2);
  scale(float(height) / float(mpg.height));
  imageMode(CENTER);
  image(mpg, 0, 0);
  imageMode(CORNER);
  popMatrix();
}
