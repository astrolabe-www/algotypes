// Based on RC4:
// https://en.wikipedia.org/wiki/RC4
// https://en.wikipedia.org/wiki/RC4#Key-scheduling_algorithm_(KSA)
// https://en.wikipedia.org/wiki/RC4#Pseudo-random_generation_algorithm_(PRGA)

// input
static final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

PRNG mPRNG;

void setup() {
  size(469, 804);
  noLoop();
}

void draw() {
  initInput();
  mPRNG = new PRNG(INPUT_NOISE);

  background(255);
  pushMatrix();
  translate(width/2, height/2);

  noStroke();
  fill(0, 100);
  for (int i = 0; i < 1e5; i++) {
    float x = map(mPRNG.random(), 0, 256, -width/2, width/2);
    float y = map(mPRNG.random(), 0, 256, -height/2, height/2);
    ellipse(x, y, 2, 2);
  }

  popMatrix();
  delay(10);
}
