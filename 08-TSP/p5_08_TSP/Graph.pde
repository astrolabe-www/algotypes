class Graph {
  private int[][] path;
  private boolean[] visited;
  private int num_cities;

  public Graph(int[] input) {
    num_cities = (int)sqrt(2 * input.length);
    path = new int[num_cities][num_cities];
    visited = new boolean[num_cities];

    for (int i = 0; i < num_cities; i++) {
      visited[i] = false;
      for (int j = i; j < num_cities; j++) {
        path[i][j] = (i == j) ? 0 : input[((num_cities >> 1) * j + i) % input.length];
        path[j][i] = path[i][j];
      }
    }
  }

  public int anneal() {
    int[] tour = new int[num_cities];
    for (int c = 1; c < tour.length; c++) {
      tour[c] = c;
    }

    int min_length = calculate_length(tour);
    int[] min_tour = tour;

    int current_length = min_length;
    int[] current_tour = tour;

    for (float temperature = 500.0; temperature > 0.1; temperature *= 0.9) {
      for (int r = 0; r < 1e5; r++) {
        int[] neighbor = shuffle(current_tour);
        int neighbor_length = calculate_length(neighbor);

        if (neighbor_length < min_length) {
          min_length = neighbor_length;
          min_tour = neighbor;
        }

        if (acceptance(current_length, neighbor_length, temperature) > random(1.0)) {
          current_length = neighbor_length;
          current_tour = neighbor;
        }
      }
    }
    return min_length;
  }

  private float acceptance(int current_length, int neighbor_length, float temperature) {
    if (neighbor_length < current_length) return 1.0;
    else return exp((current_length - neighbor_length) / temperature);
  }

  private int calculate_length(int[] tour) {
    int total_length = 0;
    for (int c = 1; c < tour.length; c++) {
      total_length += path[tour[c - 1]][tour[c]];
    }
    return total_length;
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

  public int greedy() {
    int min_length = -1;

    for (int c = 0; c < num_cities; c++) {
      for (int v = 0; v < num_cities; v++) visited[v] = (v == c);

      int length = greedy_step(c, 1, 0);

      if (min_length == -1 || length < min_length) min_length = length;
    }
    return min_length;
  }

  private int greedy_step(int current_city, int num_visited, int current_length) {
    if (num_visited == num_cities) return current_length;

    int next_length = -1;
    int next_city = -1;

    for (int c = 0; c < num_cities; c++) {
      if ((!visited[c]) && (next_length == -1 || path[current_city][c] < next_length)) {
        next_length = path[current_city][c];
        next_city = c;
      }
    }

    visited[next_city] = true;
    return greedy_step(next_city, (num_visited + 1), (current_length + next_length));
  }
}
