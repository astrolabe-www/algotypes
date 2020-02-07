// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// https://en.wikipedia.org/wiki/Primality_test#Pseudocode

// input
int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0x7fffffff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length / 4;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = 0x0;
    for (int b = 0; b < 4; b++) {
      INPUT_FRAMES[i] = INPUT_FRAMES[i] | ((in[4 * i + b] & 0xff) << (24 - 8 * b));
    }
    INPUT_FRAMES[i] = 0x3fffffff & INPUT_FRAMES[i];
  }
}

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  Primal.primes(INPUT_FRAMES);

  background(255);

  drawInputFrames();
  drawOutput();
  drawBorders(10);
}
