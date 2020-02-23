// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// https://en.wikipedia.org/wiki/Primality_test#Pseudocode

import java.util.Arrays;

String[] INPUT_FILENAME = {
  "frames_20200206-2351.raw",
  "frames_20200206-2357.raw",
  "frames_20200207-0004_reqs.raw",
  "frames_20200207-0006_beacons.raw",
  "frames_20200207-0008_data.raw",
  "frames_20200207-0010.raw",
  "frames_20200207-0012.raw"
};
int[] INPUT;
int BYTES_PER_PRIME = 2;

void initInput() {
  byte in[] = new byte[0];

  for (int i = 0; i < INPUT_FILENAME.length; i++) {
    byte file[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME[i]));
    in = Arrays.copyOf(in, in.length + file.length);
    arraycopy(file, 0, in, in.length - file.length, file.length);
  }

  INPUT = new int[in.length / BYTES_PER_PRIME];

  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = 0x0;
    for (int b = 0; b < BYTES_PER_PRIME; b++) {
      int bi = (BYTES_PER_PRIME * i + b);
      INPUT[i] = INPUT[i] | ((in[bi] & 0xff) << (8 * (BYTES_PER_PRIME - 1 - b)));
    }
    INPUT[i] = (0x3fffffff >>> (8 * (4 - BYTES_PER_PRIME))) & INPUT[i];
  }
}

static class Card {
  static final public String number = "0x13";
  static final public String name = "Primality Test";
  static final public String filename = number + "_" + name.replace(" ", "_");
}

int[] mPrimes;

void setup() {
  size(469, 804);
  noLoop();
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  initInput();
  mPrimes = Primal.primes(INPUT);
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;
int FONT_SIZE = 32;
PFont mFont;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawInput(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save(Card.filename + ".png");
  // mpg.save(Card.filename + ".jpg");
  // saveOutput(Card.filename + ".raw");

  image(mpg, 0, 0, width, height);
}
