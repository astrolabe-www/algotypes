// Based on:
// https://en.wikipedia.org/wiki/Nearest_neighbour_algorithm
// https://en.wikipedia.org/wiki/Travelling_salesman_problem#Heuristic_and_approximation_algorithms
// https://en.wikipedia.org/wiki/Simulated_annealing

// input
static final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

void initInput() {
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

Greedy mGreedy;
Annealing mAnnealing;


void setup() {
  size(469, 804);
  noLoop();
  noiseSeed(0);
}

void draw() {
  initInput();
  mGreedy = new Greedy(INPUT_NOISE);
  mAnnealing = new Annealing(INPUT_NOISE);

  background(255);

  println(mGreedy.solve());
  println(" " + mAnnealing.solve());
}
