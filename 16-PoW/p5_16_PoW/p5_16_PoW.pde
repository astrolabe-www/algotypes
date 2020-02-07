// Based on:
// https://en.bitcoin.it/wiki/Proof_of_work
// https://en.bitcoin.it/wiki/Target
// https://en.wikipedia.org/wiki/SHA-2

// input
static final int SIZE_INPUT_NOISE = 1024; 
byte[] INPUT_NOISE = new byte[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = byte(0xff * noise(i, frameCount));
  }
}

Block mBlock;

void setup() {
  size(469, 804);
  noLoop();
  noiseSeed(0);
}

void draw() {
  initInput();
  mBlock = new Block(INPUT_NOISE);
  mBlock.hash();

  background(255);
}
