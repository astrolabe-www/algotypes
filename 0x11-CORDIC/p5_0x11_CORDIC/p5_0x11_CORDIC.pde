// Based on:
// https://en.wikipedia.org/wiki/CORDIC

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
  static final public String number = "0x11";
  static final public String name = "CORDIC Trigonometric Functions";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  noLoop();
  mFont = createFont("Montserrat-Thin", OUT_SCALE * FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME);
  initInput();
}

int OUT_SCALE = (OUTPUT == Output.PRINT) ? 10 : 1;
int BORDER_WIDTH = 10;
int FONT_SIZE = 28;
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

void testZigZagOrder() {
  stroke(255);
  textSize(14);
  textAlign(CENTER, CENTER);

  int xs = width / 8;
  int ys = height / 8;

  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 8; x++) {
      String n = Integer.toString(y*8+x);
      fill(255);
      text(n, x * xs, y * ys, xs, ys);
      noFill();
      rect(x * xs, y * ys, xs, ys);
    }
  }

  int c = 0;
  fill(220, 50, 50);
  for (int i = 0; i < 8; i++) {
    boolean up = ((i % 2) == 0);
    for (int j = 0; j <= i; j++) {
      int x = up ? j : i - j;
      int y = up ? i - j : j;
      String n = "\n\n" + Integer.toString(c++);
      text(n, x * xs, y * ys, xs, ys);
    }
  }

  for (int i = 1; i < 8; i++) {
    boolean up = ((i % 2) == 1);
    for (int j = 0; j <= (7 - i); j++) {
      int x = up ? i + j : (7 - j);
      int y = up ? (7 - j) : i + j;
      String n = "\n\n" + Integer.toString(c++);
      text(n, x * xs, y * ys, xs, ys);
    }
  }
}
