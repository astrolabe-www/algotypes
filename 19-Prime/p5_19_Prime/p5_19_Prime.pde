// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// https://en.wikipedia.org/wiki/Primality_test#Pseudocode

// input
final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0x7fffffff * noise(i, frameCount));
  }
}

void setup() {
  size(469, 804);
  noLoop();
  randomSeed(0);

  byte in[] = loadBytes(sketchPath("../../esp8266/frames_20200206-2351.raw"));

  SIZE_INPUT_FRAMES = in.length / 4;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = 0x0;
    for (int b = 0; b < 4; b++) {
      INPUT_FRAMES[i] = INPUT_FRAMES[i] | ((in[4 * i + b] & 0xff) << (24 - 8 * b));
    }
    INPUT_FRAMES[i] = 0x7fffffff & INPUT_FRAMES[i];
  }
}

void draw() {
  initInput();
  Primal.primes(INPUT_FRAMES);
  background(255);
}
