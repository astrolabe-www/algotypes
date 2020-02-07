// Based on:
// https://en.wikipedia.org/wiki/PID_controller
// https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation
// https://www.csimn.com/CSI_pages/PIDforDummies.html

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
  PID mPID = new PID(INPUT_FRAMES);
  println(mPID.getError());
  background(255);
}
