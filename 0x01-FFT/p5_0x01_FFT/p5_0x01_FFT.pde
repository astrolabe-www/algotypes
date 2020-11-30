// based on Cooley–Tukey:
// https://en.wikipedia.org/wiki/Discrete_Fourier_transform
// https://en.wikipedia.org/wiki/Cooley–Tukey_FFT_algorithm

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = 2 * (in[i] & 0xff) - 256;
  }
}

static class Card {
  static final public String number = "0x01";
  static final public String name = "Fast Fourier Transform";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

Complex[] OUTPUT_DFT;
Complex[] OUTPUT_FFT;

void setup() {
  size(804, 804);
  mSetup();
  OUTPUT_DFT = Fourier.DFT(INPUT);
  OUTPUT_FFT = Fourier.FFT(INPUT);
  Fourier.testFTs(OUTPUT_DFT, OUTPUT_FFT);
}

void draw() {
  background(255);

  PGraphics mpg = createGraphics(int(OUT_SCALE * OUTPUT_DIMENSIONS.x), int(OUT_SCALE * OUTPUT_DIMENSIONS.y));
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawInputWave(mpg);
  drawOutput(mpg);
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
