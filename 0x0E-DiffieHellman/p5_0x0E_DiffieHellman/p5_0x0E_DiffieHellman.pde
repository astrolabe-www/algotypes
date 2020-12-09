// Based on:
// https://medium.com/@sadatnazrul/diffie-hellman-key-exchange-explained-python-8d67c378701c
// https://gist.github.com/cloudwu/8838724
// https://blog.cloudflare.com/a-relatively-easy-to-understand-primer-on-elliptic-curve-cryptography/

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

static class Card {
  static final public String number = "0x0E";
  static final public String name = "Diffie-Hellman Keys";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + name.replace(" ", "_");
}

void setup() {
  size(840, 840);
  mSetup();
}

void draw() {
  mDraw();
}
