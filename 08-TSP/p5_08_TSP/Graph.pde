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
