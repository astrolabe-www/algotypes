// Based on:
// https://en.wikipedia.org/wiki/PID_controller
// https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation
// https://www.csimn.com/CSI_pages/PIDforDummies.html

void initInput() {
  noiseSeed(1010);
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = int(in[i] * noise(i/100.0));
  }
}

static class Card {
  static final public String number = "0x14";
  static final public String name = "PID Control";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

PID mPID;

void setup() {
  size(804, 804);
  mSetup();
  mPID = new PID(INPUT);
}

void draw() {
  mDraw();
}
