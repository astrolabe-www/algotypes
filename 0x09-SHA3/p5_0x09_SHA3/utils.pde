enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

static Output OUTPUT = Output.SCREEN;
PVector OUTPUT_DIMENSIONS;
int OUT_SCALE;
int BORDER_WIDTH;
int FONT_SIZE;
float FONT_PADDING_FACTOR = 2.6;
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

  OUTPUT_DIMENSIONS = new PVector((OUTPUT != Output.TELEGRAM) ? 469 : 804, 804);
  OUT_SCALE = (OUTPUT == Output.PRINT) ? 10 : 1;
  BORDER_WIDTH = 10 * OUT_SCALE;
  FONT_SIZE = 18 * OUT_SCALE;

  mFont = createFont("Montserrat-Thin", FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME);
  initInput();
}

void mDraw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUT_SCALE * OUTPUT_DIMENSIONS.x), int(OUT_SCALE * OUTPUT_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawOutput(mpg);
  drawBorders(mpg, BORDER_WIDTH);

  mpg.save(Card.filename + ".png");
  if (OUTPUT != Output.SCREEN) {
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

void drawBorders(PGraphics mpg, int bwidth) {
  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.stroke(255);
  mpg.fill(255);
  mpg.rect(0, 0, mpg.width, bwidth);
  mpg.rect(0, mpg.height - bwidth, mpg.width, bwidth);
  mpg.rect(0, 0, bwidth, mpg.height);
  mpg.rect(mpg.width - bwidth, 0, bwidth, mpg.height);

  mpg.noStroke();
  mpg.textFont(mFont);
  mpg.textSize(FONT_SIZE);
  mpg.rectMode(CENTER);
  mpg.textAlign(CENTER, CENTER);
  mpg.fill(255);
  mpg.rect(mpg.width/2, bwidth, mpg.width - 2 * bwidth + 1, FONT_PADDING_FACTOR * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.number, mpg.width/2, FONT_SIZE / 1.15f);

  mpg.fill(255);
  mpg.rect(mpg.width/2, mpg.height - bwidth, mpg.width - 2 * bwidth + 1, FONT_PADDING_FACTOR * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.name, mpg.width/2, mpg.height - (FONT_SIZE / 0.92f));

  mpg.rectMode(CORNER);
  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(OUT_SCALE);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.rect(bwidth, bwidth + FONT_SIZE * (FONT_PADDING_FACTOR / 2.0f), mpg.width - 2 * bwidth, mpg.height - 2 * bwidth - FONT_PADDING_FACTOR * FONT_SIZE);

  mpg.endDraw();
}
