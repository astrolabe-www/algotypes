// Based on:
// https://en.bitcoin.it/wiki/Proof_of_work
// https://en.bitcoin.it/wiki/Target
// https://en.wikipedia.org/wiki/SHA-2

// input
static final int INPUT_SIZE = 1024; 
byte[] INPUT = new byte[INPUT_SIZE];

void initInput() {
  for (int i=0; i < INPUT_SIZE; i++) {
    INPUT[i] = byte(0xff * noise(i, frameCount));
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
  mBlock = new Block(INPUT);
  mBlock.hash();

  background(255);
}
