// Based on:
// https://keccak.team/keccak_specs_summary.html
// https://github.com/XKCP/XKCP/blob/master/Standalone/CompactFIPS202/Python/CompactFIPS202.py

byte[] INPUT_BYTES;

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT_BYTES = new byte[in.length];
  for (int i = 0; i < INPUT_BYTES.length; i++) {
    INPUT_BYTES[i] = byte(in[i] & 0xff);
  }
}

static class Card {
  static final public String number = "0x09";
  static final public String name = "SHA3-512";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Keccak mKeccak;

void setup() {
  size(840, 840);
  mSetup();
  mKeccak = new Keccak(576, 1024);
  byte[] r = mKeccak.SHA3("hello world".getBytes());
  println(hexString(r));
}

void draw() {
  mDraw();
}
