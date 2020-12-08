// Based on:
// https://en.wikipedia.org/wiki/Nearest_neighbour_algorithm
// https://en.wikipedia.org/wiki/Travelling_salesman_problem#Heuristic_and_approximation_algorithms
// https://en.wikipedia.org/wiki/Simulated_annealing

void initInput() {
  byte in[] = loadBytes(INPUT_FILEPATH);
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = (in[i] & 0xff) + 1;
  }
}

static class Card {
  static final public String number = "0x07";
  static final public String name = "Travelling Salesperson";
  static final public String filename = OUTPUT.name() + "_" + number + "_" + name.replace(" ", "_");
}

Greedy mGreedy;
Annealing mAnnealing;

void setup() {
  size(804, 804);
  mSetup();
  mGreedy = new Greedy(INPUT);
  mAnnealing = new Annealing(INPUT);
}

void draw() {
  mDraw();
}
