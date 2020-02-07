// Based on:
// https://en.bitcoin.it/wiki/Proof_of_work
// https://en.bitcoin.it/wiki/Target
// https://en.wikipedia.org/wiki/SHA-2

// input
final int SIZE_INPUT_NOISE = 1024;
byte[] INPUT_NOISE = new byte[SIZE_INPUT_NOISE];

int SIZE_INPUT_FRAMES;
byte[] INPUT_FRAMES;

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

  byte in[] = loadBytes(sketchPath("../../esp8266/frames_20200206-2351.raw"));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new byte[SIZE_INPUT_FRAMES];
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = byte(in[i] & 0xff);
  }
}

void draw() {
  initInput();
  mBlock = new Block(INPUT_FRAMES);
  mBlock.hash();

  background(255);
}
