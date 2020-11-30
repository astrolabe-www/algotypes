// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// https://en.wikipedia.org/wiki/Primality_test#Pseudocode

import java.util.Arrays;

int BYTES_PER_PRIME = 2;

void initInput() {
  byte in[] = new byte[0];

  for (int i = 0; i < INPUT_FILENAME_LIST.length; i++) {
    byte file[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME_LIST[i]));
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
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

int[] mPrimes;

void setup() {
  size(804, 804);
  mSetup();
  mPrimes = Primal.primes(INPUT);
}

void draw() {
  mDraw();
}
