// Based on:
// https://keccak.team/keccak_specs_summary.html
// https://github.com/XKCP/XKCP/blob/master/Standalone/CompactFIPS202/Python/CompactFIPS202.py

enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

Output OUTPUT = Output.SCREEN;
PVector OUTPUT_DIMENSIONS = new PVector((OUTPUT != Output.TELEGRAM) ? 469 : 804, 804);

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
String INPUT_FILEPATH;
byte[] INPUT;

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new byte[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = byte(in[i] & 0xff);
  }
}

static class Card {
  static final public String number = "0x09";
  static final public String name = "SHA3-512";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

Keccak mKeccak;

void setup() {
  size(804, 804);
  noLoop();
  mFont = createFont("Montserrat-Thin", FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME);
  initInput();
  mKeccak = new Keccak(576, 1024);
  byte[] r = mKeccak.SHA3("hello world".getBytes());
  println(hexString(r));
}

int OUT_SCALE = (OUTPUT == Output.PRINT) ? 10 : 1;
int BORDER_WIDTH = 10 * OUT_SCALE;
int FONT_SIZE = 18 * OUT_SCALE;
float FONT_PADDING_FACTOR = 2.6;
PFont mFont;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUT_SCALE * OUTPUT_DIMENSIONS.x), int(OUT_SCALE * OUTPUT_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawOutput(mpg, BORDER_WIDTH);
  drawBorders(mpg, BORDER_WIDTH);

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
