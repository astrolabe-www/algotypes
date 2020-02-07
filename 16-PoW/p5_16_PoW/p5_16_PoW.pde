// Based on:
// https://en.bitcoin.it/wiki/Proof_of_work
// https://en.bitcoin.it/wiki/Target
// https://en.wikipedia.org/wiki/SHA-2

// input
int SIZE_INPUT_NOISE = 1024;
byte[] INPUT_NOISE = new byte[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
byte[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = byte(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new byte[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = byte(in[i] & 0xff);
  }
}

Block mBlock;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  mBlock = new Block(INPUT_FRAMES);
  mBlock.hash();

  background(255);

  drawInputFrames();
  drawOutput();
  drawBorders(10);
}
