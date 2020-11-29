//
//

enum Output {
  SCREEN,
  PRINT,
  TELEGRAM
}

Output OUTPUT = Output.SCREEN;
PVector OUTPUT_DIMENSIONS = new PVector((OUTPUT != Output.TELEGRAM) ? 469 : 804, 804);

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
  static final public String number = "0xFF";
  static final public String name = "back";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

void setup() {
  size(804, 804);
  noLoop();
  initInput();
}

int OUT_SCALE = (OUTPUT == Output.PRINT) ? 10 : 1;
int BORDER_WIDTH = 10 * OUT_SCALE;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUT_SCALE * OUTPUT_DIMENSIONS.x), int(OUT_SCALE * OUTPUT_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255, 255);
  mpg.endDraw();

  drawInput(mpg);
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
