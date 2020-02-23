// Based on:
// http://pi.math.cornell.edu/~web6140/TopTenAlgorithms/JPEG.html
// https://en.wikipedia.org/wiki/JPEG#Quantization
// https://en.wikipedia.org/wiki/JPEG#Discrete_cosine_transform

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
  static final public String number = "0x0F";
  static final public String name = "JPEG";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

JFIF mJFIF;

void setup() {
  size(469, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
  mJFIF = new JFIF(INPUT);
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
  // saveOutput(Card.filename + ".raw");

  image(mpg, 0, 0, width, height);
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
