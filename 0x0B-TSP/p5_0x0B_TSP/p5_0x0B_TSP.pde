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
  static final public String number = "0x0B";
  static final public String nameEN = "Travelling Salesperson";
  static final public String namePT = "Caixeiro-Viajante";
  static final public String filename = OUTPUT.name() + "_" + (BLEED_WIDTH ? "WIDE_" : "") + number + "_" + nameEN.replace(" ", "_");
}

Greedy mGreedy;
Annealing mAnnealing;

void setup() {
  size(840, 840);
  mSetup();
  mGreedy = new Greedy(INPUT);
  mAnnealing = new Annealing(INPUT);
}

void draw() {
  mDraw();
}
