#ifndef _GREEDY_CLASS_
#define _GREEDY_CLASS_

#include <vector>
#include <math.h>

class Greedy {
  private:
    std::vector< std::vector<int> > path;
    int num_cities;
    std::vector<bool> visited;
    std::vector<int> current_tour;

    int greedy_step(int current_city, int num_visited, int current_distance) {
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
      return greedy_step(next_city, (num_visited + 1), (current_distance + next_distance));
    }


  public:
    std::vector<int> tour;
    int min_distance;

    Greedy(int* input, int input_length) {
      num_cities = (int)(sqrt(2 * input_length));

      for (int i = 0; i < num_cities; i++) {
        visited.push_back(false);
        current_tour.push_back(-1);

        std::vector<int> row;
        for (int j = 0; j < num_cities; j++) {
          row.push_back(0);
        }
        path.push_back(row);
      }

      for (int i = 0; i < num_cities; i++) {
        for (int j = i; j < num_cities; j++) {
          path[i][j] = (i == j) ? 0 : input[((num_cities >> 1) * j + i) % input_length];
          path[j][i] = path[i][j];
        }
      }
    }

    std::vector<int> solve() {
      min_distance = -1;

      for (int c = 0; c < num_cities; c++) {
        for (int i = 0; i < num_cities; i++) {
          current_tour[i] = -1;
          visited[i] = (i == c);
        }

        current_tour[0] = c;
        int distance = greedy_step(c, 1, 0);

        if (min_distance == -1 || distance < min_distance) {
          min_distance = distance;
          tour = current_tour;
        }
      }

      return tour;
    }
};

#endif
