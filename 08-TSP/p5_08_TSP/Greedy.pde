class Greedy {
  protected int[][] path;
  protected int num_cities;
  protected int[] tour;

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
    tour = new int[num_cities];

    for (int c = 0; c < num_cities; c++) {
      int[] current_tour = new int[num_cities];
      for (int v = 0; v < num_cities; v++) visited[v] = (v == c);

      current_tour[0] = c;
      int distance = greedy_step(c, 1, 0, visited, current_tour);

      if (min_distance == -1 || distance < min_distance) {
        min_distance = distance;
        tour = current_tour;
      }
    }

    return min_distance;
  }

  private int greedy_step(int current_city, int num_visited, int current_distance, boolean[] visited, int[] current_tour) {
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
    current_tour[num_visited] = next_city;
    return greedy_step(next_city, (num_visited + 1), (current_distance + next_distance), visited, current_tour);
  }

  protected int calculate_cost(int[] tour) {
    int total_cost = 0;
    for (int c = 1; c < tour.length; c++) {
      total_cost += path[tour[c - 1]][tour[c]];
    }
    return total_cost;
  }

  public void drawCities_(int bwidth) {
    if (tour == null) this.solve();
    fill(255, 0, 0, 20);
    for (int i = 0; i < num_cities; i++) {
    }
  }

  public void drawCities(int bwidth) {
    if (tour == null) this.solve();

    randomSeed(1010);

    PVector[] location = new PVector[num_cities];
    location[tour[0]] = new PVector(width / 2, 0.75 * height);

    for (int i = 1; i < num_cities; i++) {
      float d = map(path[tour[i-1]][tour[i]], 0, 0xff, bwidth, 32 * height);
      float a = random(0, TWO_PI);

      float mx = location[tour[i-1]].x + d * cos(a);
      float my = location[tour[i-1]].y + d * sin(a);

      location[tour[i]] = new PVector(
        constrain(mx, bwidth + 2, width - bwidth - 2),
        constrain(my, bwidth + 2, height - bwidth - 2));

      noStroke();
      fill(255, 0, 0, 20);
      ellipse(location[tour[i]].x, location[tour[i]].y, 4, 4);

      stroke(255, 0, 0, 100);
      line(location[tour[i]].x,
        location[tour[i]].y,
        location[tour[(i - 1)]].x,
        location[tour[(i - 1)]].y);
    }
  }
}
