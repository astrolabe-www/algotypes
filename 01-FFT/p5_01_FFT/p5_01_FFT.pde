// based on Cooley–Tukey:
// https://en.wikipedia.org/wiki/Discrete_Fourier_transform
// https://en.wikipedia.org/wiki/Cooley–Tukey_FFT_algorithm

String INPUT_FILENAME = "frames_20200207-0004_reqs.raw";
int[] INPUT;

void initInput() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FILENAME));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = 2 * (in[i] & 0xff) - 256;
  }
}

static class Card {
  static final public String number = "0x01";
  static final public String name = "FFT";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

Complex[] OUTPUT_DFT;
Complex[] OUTPUT_FFT;

void setup() {
  size(469, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
  OUTPUT_DFT = Fourier.DFT(INPUT);
  OUTPUT_FFT = Fourier.FFT(INPUT);
  Fourier.testFTs(OUTPUT_DFT, OUTPUT_FFT);
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
  drawInputWave(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save(Card.filename + ".png");
  // mpg.save(Card.filename + ".jpg");
  // saveOutput(Card.filename + ".byt");

  image(mpg, 0, 0, width, height);
}
