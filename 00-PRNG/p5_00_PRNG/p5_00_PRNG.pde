// Based on RC4:
// https://en.wikipedia.org/wiki/RC4
// https://en.wikipedia.org/wiki/RC4#Key-scheduling_algorithm_(KSA)
// https://en.wikipedia.org/wiki/RC4#Pseudo-random_generation_algorithm_(PRGA)

static final int[] KEY = {0xde, 0xad, 0xbe, 0xef, 0xba, 0xba, 0xca, 0xca};

PRNG mnr;

void setup() {
  size(469, 804);
  background(255);

  noStroke();
  fill(0, 100);

  mnr = new PRNG(KEY);
}

void draw() {
  pushMatrix();
  translate(width/2, height/2);

  for (int i = 0; i < 1e3; i++) {
    float x = map(mnr.random(), 0, 256, -width/2, width/2);
    float y = map(mnr.random(), 0, 256, -height/2, height/2);
    ellipse(x, y, 1, 1);
  }

  popMatrix();
  delay(100);
}
