// Based on:
// https://en.wikipedia.org/wiki/PID_controller
// https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation
// https://www.csimn.com/CSI_pages/PIDforDummies.html

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
  noiseSeed(1010);
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = int(in[i] * noise(i/100.0));
  }
}

static class Card {
  static final public String number = "0x08";
  static final public String name = "PID Control";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

PID mPID;

void setup() {
  size(804, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  INPUT_FILEPATH = sketchPath("../../Packets/in/" + INPUT_FILENAME);
  initInput();
  mPID = new PID(INPUT);
  println("Error: " + mPID.getError());
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

  drawInput(mpg, INPUT_FILEPATH);
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
