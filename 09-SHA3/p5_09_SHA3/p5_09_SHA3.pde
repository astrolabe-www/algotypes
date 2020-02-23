// Based on:
// https://keccak.team/keccak_specs_summary.html
// https://github.com/XKCP/XKCP/blob/master/Standalone/CompactFIPS202/Python/CompactFIPS202.py

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
byte[] INPUT;

void initInput() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FILENAME));
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
  size(469, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
  mKeccak = new Keccak(576, 1024);
  byte[] r = mKeccak.SHA3("hello world".getBytes());
  println(hexString(r));
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
  drawOutput(mpg, OUT_SCALE * BORDER_WIDTH);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save(Card.filename + ".png");
  // mpg.save(Card.filename + ".jpg");
  // saveOutput(Card.filename + ".byt");

  image(mpg, 0, 0, width, height);
}
