class Annealing {
  private int[][] path;
  private int num_cities;

  public Annealing(int[] input) {
    num_cities = (int)sqrt(2 * input.length);
    path = new int[num_cities][num_cities];

    for (int i = 0; i < num_cities; i++) {
      for (int j = i; j < num_cities; j++) {
        path[i][j] = (i == j) ? 0 : input[((num_cities >> 1) * j + i) % input.length];
        path[j][i] = path[i][j];
      }
    }
  }

  public int solve() {
    int[] tour = new int[num_cities];
    for (int c = 1; c < tour.length; c++) {
      tour[c] = c;
    }

    int min_cost = calculate_cost(tour);
    int[] min_tour = tour;

    int current_cost = min_cost;
    int[] current_tour = tour;

    for (float temperature = 500.0; temperature > 0.1; temperature *= 0.9) {
      for (int r = 0; r < 1e5; r++) {
        int[] candidate = shuffle(current_tour);
        int candidate_cost = calculate_cost(candidate);

        if (candidate_cost < min_cost) {
          min_cost = candidate_cost;
          min_tour = candidate;
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

  private int calculate_cost(int[] tour) {
    int total_cost = 0;
    for (int c = 1; c < tour.length; c++) {
      total_cost += path[tour[c - 1]][tour[c]];
    }
    return total_cost;
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
