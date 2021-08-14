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
  static final public String nameEN = "Fast Fourier Transform";
  static final public String namePT = "Transformação de Fourier";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}

Complex[] OUTPUT_DFT;
Complex[] OUTPUT_FFT;

void setup() {
  size(840, 840);
  mSetup();
  OUTPUT_DFT = Fourier.DFT(INPUT);
  OUTPUT_FFT = Fourier.FFT(INPUT);
  //Fourier.testFTs(OUTPUT_DFT, OUTPUT_FFT);
}

void draw() {
  mDraw();
}
