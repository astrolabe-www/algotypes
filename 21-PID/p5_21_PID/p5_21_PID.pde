// Based on:
// https://en.wikipedia.org/wiki/PID_controller
// https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation
// https://www.csimn.com/CSI_pages/PIDforDummies.html

// input
static final int INPUT_SIZE = 1024; 
byte[] INPUT = new byte[INPUT_SIZE];

void initInput() {
  for (int i=0; i < INPUT_SIZE; i++) {
    INPUT[i] = byte(0xff * noise(i, frameCount));
  }
}

void setup() {
  size(469, 804);
  noLoop();
  noiseSeed(0);
}

void draw() {
  initInput();
  PID mPID = new PID(INPUT);
  println(mPID.getError());
  background(255);
}
