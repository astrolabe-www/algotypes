enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

static Output OUTPUT = Output.SCREEN;
static boolean BLEED_WIDTH = false;
static boolean BLEED_HEIGHT = false;

PVector OUTPUT_DIMENSIONS;
PVector OUTPUT_GRAPHICS_DIMENSIONS;
int CARD_HEIGHT;
int CARD_WIDTH;
float OUT_SCALE;
int BORDER_WIDTH;
int FONT_SIZE;
int FONT_PADDING;
int COLOR_RED;
PFont mFont;

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
String[] INPUT_FILENAME_LIST = {
  "frames_20200206-2351.raw",
  "frames_20200206-2357.raw",
  "frames_20200207-0004_reqs.raw",
  "frames_20200207-0006_beacons.raw",
  "frames_20200207-0008_data.raw",
  "frames_20200207-0010.raw",
  "frames_20200207-0012.raw"
};

String INPUT_FILEPATH;
int[] INPUT;

void mSetup() {
  noLoop();

  if (args == null) {
    OUTPUT = Output.SCREEN;
  } else if (args[0].equals("PRINT")) {
    OUTPUT = Output.PRINT;
  } else if (args[0].equals("TELEGRAM")) {
    OUTPUT = Output.TELEGRAM;
  }

  if (args != null && args.length > 1 && args[1].equals("BLEED")) BLEED_WIDTH = true;

  CARD_HEIGHT = 840;
  CARD_WIDTH = int(0.6 * CARD_HEIGHT);
  OUT_SCALE = (OUTPUT == Output.PRINT) ? 2 : 1;
  OUTPUT_DIMENSIONS = (new PVector((OUTPUT != Output.TELEGRAM) ? CARD_WIDTH : CARD_HEIGHT, CARD_HEIGHT)).mult(OUT_SCALE);
  BORDER_WIDTH = int(0.076 * OUT_SCALE * CARD_HEIGHT);
  FONT_SIZE = int(25 * OUT_SCALE);
  FONT_PADDING = int(1 * OUT_SCALE);
  COLOR_RED = 200;

  OUTPUT_GRAPHICS_DIMENSIONS = OUTPUT_DIMENSIONS.copy().sub(2 * BORDER_WIDTH, 2.3333 * BORDER_WIDTH, 0);
  if (BLEED_WIDTH) OUTPUT_GRAPHICS_DIMENSIONS = OUTPUT_DIMENSIONS.copy().sub(0, 2.3333 * BORDER_WIDTH, 0);

  mFont = createFont("../../fonts/Montserrat-Light.ttf", FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME);
  initInput();
}

void mDraw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUTPUT_DIMENSIONS.x), int(OUTPUT_DIMENSIONS.y));
  PGraphics mpo = createGraphics(int(OUTPUT_GRAPHICS_DIMENSIONS.x), int(OUTPUT_GRAPHICS_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawOutput(mpo);
  drawOutputAndBorders(mpo, mpg);

  mpg.save(Card.filename + ".png");
  if (args != null) {
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

void drawInput(PGraphics mpg, String fileName) {
  byte in[] = loadBytes(fileName);

  mpg.beginDraw();
  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < in.length; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(in[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(in[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawBorders(PGraphics mpg) {
  mpg.beginDraw();

  mpg.noStroke();
  mpg.textFont(mFont);
  mpg.textSize(FONT_SIZE);

  mpg.fill(0);
  mpg.textAlign(CENTER, BOTTOM);
  mpg.text(Card.number, mpg.width/2, (mpg.height - OUTPUT_GRAPHICS_DIMENSIONS.y) / 2.0 - FONT_PADDING);

  mpg.fill(0);
  mpg.textAlign(CENTER, TOP);
  mpg.text(Card.name, mpg.width/2, (mpg.height + OUTPUT_GRAPHICS_DIMENSIONS.y) / 2.0 + FONT_PADDING);

  mpg.rectMode(CORNER);
  mpg.noFill();
  mpg.stroke(0);
  mpg.strokeWeight(OUT_SCALE);

  mpg.rect(0, 1, mpg.width - 1, mpg.height - 2);

  if (!BLEED_HEIGHT)
    mpg.rect((mpg.width - OUTPUT_GRAPHICS_DIMENSIONS.x) / 2, (mpg.height - OUTPUT_GRAPHICS_DIMENSIONS.y) / 2, OUTPUT_GRAPHICS_DIMENSIONS.x, OUTPUT_GRAPHICS_DIMENSIONS.y);

  mpg.endDraw();
}

void drawOutputAndBorders(PGraphics mpo, PGraphics mpg) {
  mpg.beginDraw();
  mpg.background(255);

  mpg.pushMatrix();
  mpg.translate(mpg.width/ 2, mpg.height / 2);
  mpg.imageMode(CENTER);
  mpg.image(mpo, 0, 0);
  mpg.imageMode(CORNER);
  mpg.popMatrix();
  mpg.endDraw();

  drawBorders(mpg);
}
