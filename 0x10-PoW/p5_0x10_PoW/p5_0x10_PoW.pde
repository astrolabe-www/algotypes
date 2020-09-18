// Based on:
// https://en.bitcoin.it/wiki/Proof_of_work
// https://en.bitcoin.it/wiki/Target
// https://en.wikipedia.org/wiki/SHA-2

enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

Output OUTPUT = Output.SCREEN;
PVector OUTPUT_DIMENSIONS = new PVector((OUTPUT != Output.TELEGRAM) ? 469 : 804, 804);

String[] INPUT_FILENAME = {
  "frames_20200206-2351.raw",
  "frames_20200206-2357.raw",
  "frames_20200207-0004_reqs.raw",
  "frames_20200207-0006_beacons.raw",
  "frames_20200207-0008_data.raw",
  "frames_20200207-0010.raw",
  "frames_20200207-0012.raw"
};
String INPUT_FILEPATH;
byte[][] INPUT;

void initInput() {
  INPUT = new byte[INPUT_FILENAME.length][];
  for (int i = 0; i < INPUT_FILENAME.length; i++) {
    byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME[i]));
    INPUT[i] = new byte[in.length];
    for (int b = 0; b < INPUT[i].length; b++) {
      INPUT[i][b] = byte(in[b] & 0xff);
    }
  }
}

static class Card {
  static final public String number = "0x10";
  static final public String name = "Blockchain Proof-of-Work";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

Block[] chain;

void setup() {
  size(804, 804);
  noLoop();
  mFont = createFont("Montserrat-Thin", OUT_SCALE * FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME[2]);
  initInput();
  chain = new Block[INPUT.length];

  chain[0] = new Block(INPUT[0]);
  for (int i = 1; i < chain.length; i++) {
    chain[i] = new Block(INPUT[i], chain[i-1].hash(), chain[i-1].nextTarget());
  }
}

int OUT_SCALE = (OUTPUT == Output.PRINT) ? 10 : 1;
int BORDER_WIDTH = 10;
int FONT_SIZE = 18;
float FONT_PADDING_FACTOR = 2.6;
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
