// Based on:
// https://en.bitcoin.it/wiki/Proof_of_work
// https://en.bitcoin.it/wiki/Target
// https://en.wikipedia.org/wiki/SHA-2

byte[][] INPUT_LIST;

void initInput() {
  INPUT_LIST = new byte[INPUT_FILENAME_LIST.length][];
  for (int i = 0; i < INPUT_FILENAME_LIST.length; i++) {
    byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME_LIST[i]));
    INPUT_LIST[i] = new byte[in.length];
    for (int b = 0; b < INPUT_LIST[i].length; b++) {
      INPUT_LIST[i][b] = byte(in[b] & 0xff);
    }
  }
}

static class Card {
  static final public String number = "0x10";
  static final public String name = "Blockchain Proof-of-Work";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Block[] chain;

void setup() {
  size(840, 840);
  mSetup();

  chain = new Block[INPUT_LIST.length];

  chain[0] = new Block(INPUT_LIST[0]);
  for (int i = 1; i < chain.length; i++) {
    chain[i] = new Block(INPUT_LIST[i], chain[i-1].hash(), chain[i-1].nextTarget());
  }
}

void draw() {
  mDraw();
}
