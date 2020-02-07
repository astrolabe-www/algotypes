// based on Cooley–Tukey:
// https://en.wikipedia.org/wiki/Discrete_Fourier_transform
// https://en.wikipedia.org/wiki/Cooley–Tukey_FFT_algorithm

final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

Complex[] OUTPUT_DFT;
Complex[] OUTPUT_FFT;

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * (2.0 * noise(i/1e2, frameCount) - 1.0));
    //INPUT_NOISE[i] = int(0xff * sin(TWO_PI*(float(i)/SIZE_INPUT_NOISE)));
    //INPUT_NOISE[i] = int(0xff * sin(TWO_PI*(4.0*float(i)/SIZE_INPUT_NOISE)));
    //INPUT_NOISE[i] = int(0x80 * sin(TWO_PI*(float(i)/SIZE_INPUT_NOISE))) + int(0x80 * sin(TWO_PI*(5.0*float(i)/SIZE_INPUT_NOISE)));
    /*
    INPUT_NOISE[i] = int(0x40 * sin(TWO_PI*(float(i)/SIZE_INPUT_NOISE))) +
     int(0x40 * sin(TWO_PI*(3.0*float(i)/SIZE_INPUT_NOISE))) +
     int(0x40 * sin(TWO_PI*(5.0*float(i)/SIZE_INPUT_NOISE))) +
     int(0x40 * sin(TWO_PI*(11.0*float(i)/SIZE_INPUT_NOISE)));
    /**/
  }
}

void setup() {
  size(469, 804);
  noLoop();

  byte in[] = loadBytes(sketchPath("../../esp8266/frames_20200206-2351.raw"));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
    INPUT_FRAMES[i] = 2 * INPUT_FRAMES[i] - 256;
  }
}

void draw() {
  initInput();
  OUTPUT_DFT = Fourier.DFT(INPUT_FRAMES);
  OUTPUT_FFT = Fourier.FFT(INPUT_FRAMES);
  Fourier.testFTs(OUTPUT_DFT, OUTPUT_FFT);

  background(255);
  pushMatrix();
  translate(width/2, 0);

  stroke(0, 64);
  strokeWeight(1);
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    float x = map(INPUT_FRAMES[i], -(0xff), 0xff, -width/2, width/2);
    float y = map(i, 0, SIZE_INPUT_FRAMES, 0, height);
    line(0, y, x, y);
  }

  stroke(255, 0, 0, 64);
  strokeWeight(3);
  for (int i=0; i < OUTPUT_DFT.length; i++) {
    float mag = OUTPUT_DFT[i].magnitude() / OUTPUT_DFT.length;
    float x = map(mag, 0, 0xff, 1, width / 2);
    float y = map(i, 0, OUTPUT_DFT.length, 0, 16*height);
    line(0, y, x, y);
  }

  stroke(0, 0, 255, 64);
  strokeWeight(3);
  for (int i=0; i < OUTPUT_FFT.length; i++) {
    float mag = OUTPUT_FFT[i].magnitude() / OUTPUT_FFT.length;
    float x = map(mag, 0, 0xff, 1, width / 2);
    float y = map(i, 0, OUTPUT_FFT.length, 0, 16*height);
    line(0, y, x, y);
  }

  popMatrix();
  delay(10);
}
