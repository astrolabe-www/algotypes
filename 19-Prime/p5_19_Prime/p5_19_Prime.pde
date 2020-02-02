// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// 
// 

// input
static final int INPUT_SIZE = 1024; 
int[] INPUT = new int[INPUT_SIZE];

void initInput() {
  for (int i=0; i < INPUT_SIZE; i++) {
    INPUT[i] = int(0x7fffffff * random(1.0));
  }
}

void setup() {
  size(469, 804);
  noLoop();
  randomSeed(0);
}

void draw() {
  initInput();
  Primal.primes(INPUT);
  background(255);
}
