class Greedy {
  private int[][] path;
  private int num_cities;

  public Greedy(int[] input) {
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
    int min_distance = -1;
    boolean[] visited = new boolean[num_cities];

    for (int c = 0; c < num_cities; c++) {
      for (int v = 0; v < num_cities; v++) visited[v] = (v == c);

      int distance = greedy_step(c, 1, 0, visited);

      if (min_distance == -1 || distance < min_distance) min_distance = distance;
    }
    return min_distance;
  }

  private int greedy_step(int current_city, int num_visited, int current_distance, boolean[] visited) {
    if (num_visited == num_cities) return current_distance;

    int next_distance = -1;
    int next_city = -1;

    for (int c = 0; c < num_cities; c++) {
      if ((!visited[c]) && (next_distance == -1 || path[current_city][c] < next_distance)) {
        next_distance = path[current_city][c];
        next_city = c;
      }
    }

    visited[next_city] = true;
    return greedy_step(next_city, (num_visited + 1), (current_distance + next_distance), visited);
  }
}
