class Annealing extends Greedy {
  public Annealing(int[] input) {
    super(input);
  }

  public int solve() {
    tour = new int[num_cities];
    for (int c = 0; c < tour.length; c++) tour[c] = c;

    int min_cost = calculate_cost(tour);

    int current_cost = min_cost;
    int[] current_tour = tour;

    for (float temperature = 500.0; temperature > 0.1; temperature *= 0.9) {
      for (int r = 0; r < 1e5; r++) {
        int[] candidate = shuffle(current_tour);
        int candidate_cost = calculate_cost(candidate);

        if (candidate_cost < min_cost) {
          min_cost = candidate_cost;
          tour = candidate;
        }

        if (acceptance(current_cost, candidate_cost, temperature) > random(1.0)) {
          current_cost = candidate_cost;
          current_tour = candidate;
        }
      }
    }

    return min_cost;
  }

  private float acceptance(int current_cost, int candidate_cost, float temperature) {
    if (candidate_cost < current_cost) return 1.0;
    else return exp((current_cost - candidate_cost) / temperature);
  }

  private int[] shuffle(int[] tour) {
    int[] result = tour.clone();
    int i0 = floor(random(tour.length));
    int i1 = floor(random(tour.length));
    int t = result[i1];
    result[i1] = result[i0];
    result[i0] = t;
    return result;
  }
}
