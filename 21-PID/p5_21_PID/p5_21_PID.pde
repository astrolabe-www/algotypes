// Based on:
// https://en.wikipedia.org/wiki/PID_controller
// https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation
// https://www.csimn.com/CSI_pages/PIDforDummies.html

// input
static final int SIZE_INPUT_NOISE = 1024; 
byte[] INPUT_NOISE = new byte[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = byte(0xff * noise(i, frameCount));
  }
}

void setup() {
  size(469, 804);
  noLoop();
  noiseSeed(0);
}

void draw() {
  initInput();
  PID mPID = new PID(INPUT_NOISE);
  println(mPID.getError());
  background(255);
}
