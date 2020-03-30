// based on:
// https://rosettacode.org/wiki/Sorting_algorithms/Quicksort

enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

Output OUTPUT = Output.SCREEN;
PVector OUTPUT_DIMENSIONS = new PVector((OUTPUT != Output.TELEGRAM) ? 469 : 804, 804);

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
int[] INPUT;

int BYTES_PER_NUMBER = 1;
int MAX_RANDOM_NUMBER = (int)pow(2, (BYTES_PER_NUMBER * 8)) - 1;

void initInput() {
  randomSeed(1010);
  byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = 0;
    for (int b = 0; b < BYTES_PER_NUMBER; b++) {
      INPUT[i] |= (in[(BYTES_PER_NUMBER * i + b) % in.length] & 0xff) << ((BYTES_PER_NUMBER - 1 - b) * 8);
    }
    INPUT[i] = ((INPUT[i] > 1) && (INPUT[i] < MAX_RANDOM_NUMBER)) ? INPUT[i] : (int)random(1, MAX_RANDOM_NUMBER);
  }
}

static class Card {
  static final public String number = "0x06";
  static final public String name = "GCD";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
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

  drawInput(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);

  if (OUTPUT != Output.SCREEN) {
    mpg.save(Card.filename + ".png");
    mpg.save(Card.filename + ".jpg");
  }

  pushMatrix();
  translate(width/ 2, height / 2);
  scale(float(height) / float(mpg.height));
  imageMode(CENTER);
  image(mpg, 0, 0);
  imageMode(CORNER);
  popMatrix();
}
