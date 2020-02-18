// based on Cooley–Tukey:
// https://en.wikipedia.org/wiki/Discrete_Fourier_transform
// https://en.wikipedia.org/wiki/Cooley–Tukey_FFT_algorithm

int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * (2.0 * noise(i/1e2, frameCount) - 1.0));
    //INPUT_NOISE[i] = int(0xff * sin(TWO_PI*(float(i)/SIZE_INPUT_NOISE)));
    //INPUT_NOISE[i] = int(0xff * sin(TWO_PI*(4.0*float(i)/SIZE_INPUT_NOISE)));
    //INPUT_NOISE[i] = int(0x80 * sin(TWO_PI*(float(i)/SIZE_INPUT_NOISE))) + int(0x80 * sin(TWO_PI*(5.0*float(i)/SIZE_INPUT_NOISE)));
    /*INPUT_NOISE[i] = int(0x40 * sin(TWO_PI*(float(i)/SIZE_INPUT_NOISE))) +
     int(0x40 * sin(TWO_PI*(3.0*float(i)/SIZE_INPUT_NOISE))) +
     int(0x40 * sin(TWO_PI*(5.0*float(i)/SIZE_INPUT_NOISE))) +
     int(0x40 * sin(TWO_PI*(11.0*float(i)/SIZE_INPUT_NOISE)));
    /**/
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
    INPUT_FRAMES[i] = 2 * INPUT_FRAMES[i] - 256;
  }
}

Complex[] OUTPUT_DFT;
Complex[] OUTPUT_FFT;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;

void draw() {
  OUTPUT_DFT = Fourier.DFT(INPUT_FRAMES);
  OUTPUT_FFT = Fourier.FFT(INPUT_FRAMES);
  Fourier.testFTs(OUTPUT_DFT, OUTPUT_FFT);

  background(255);

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255, 0);
  mpg.endDraw();

  drawInputFrames(mpg);
  drawInputWave(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save("out.png");
  // mpg.save("out.jpg");

  image(mpg, 0, 0, width, height);
}
