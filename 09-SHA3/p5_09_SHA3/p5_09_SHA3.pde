// Based on:
// https://keccak.team/keccak_specs_summary.html
// https://github.com/XKCP/XKCP/blob/master/Standalone/CompactFIPS202/Python/CompactFIPS202.py

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

Keccak mKeccak;

void setup() {
  size(469, 804);
  noLoop();

  byte in[] = loadBytes(sketchPath("../../esp8266/frames_20200206-2351.raw"));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new byte[SIZE_INPUT_FRAMES];
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = byte(in[i] & 0xff);
  }
}

void draw() {
  initInput();
  mKeccak = new Keccak(576, 1024);

  background(255);

  //println(new String(mKeccak.SHA3("hello world".getBytes())));
  //byte[] r = mKeccak.SHA3("HELLO world".getBytes());

  byte[] r = mKeccak.SHA3(INPUT_FRAMES);

  for (int i = 0; i < r.length; i++) {
    print(int(r[i]) + " ");
  }
}
