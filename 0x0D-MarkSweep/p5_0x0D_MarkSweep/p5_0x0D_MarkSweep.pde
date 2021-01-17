// Based on Mark and Sweep GC:
// http://journal.stuffwithstuff.com/2013/12/08/babys-first-garbage-collector/
// https://en.wikipedia.org/wiki/Tracing_garbage_collection
// https://www.geeksforgeeks.org/mark-and-sweep-garbage-collection-algorithm/


void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0D";
  static final public String name = "Mark & Sweep";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_").replace("&", "n");
}

VM mVM;

void setup() {
  size(840, 840);
  mSetup();
  mVM = new VM(INPUT);
}

void draw() {
  mDraw();
}
