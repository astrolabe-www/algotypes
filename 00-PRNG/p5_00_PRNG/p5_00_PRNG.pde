// Based on RC4:
// https://en.wikipedia.org/wiki/RC4
// https://en.wikipedia.org/wiki/RC4#Key-scheduling_algorithm_(KSA)
// https://en.wikipedia.org/wiki/RC4#Pseudo-random_generation_algorithm_(PRGA)

int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
  }
}

PRNG mPRNG;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  mPRNG = new PRNG(INPUT_FRAMES);

  background(255);

  drawInputFrames();
  drawOutput();
  drawBorders(10);

  delay(10);
}
