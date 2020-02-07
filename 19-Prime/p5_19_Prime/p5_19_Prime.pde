// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// https://en.wikipedia.org/wiki/Primality_test#Pseudocode

// input
static final int SIZE_INPUT_NOISE = 1024; 
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0x7fffffff * random(1.0));
  }
}

void setup() {
  size(469, 804);
  noLoop();
  randomSeed(0);
}

void draw() {
  initInput();
  Primal.primes(INPUT_NOISE);
  background(255);
}
