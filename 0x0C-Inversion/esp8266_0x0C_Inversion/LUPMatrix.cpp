#ifndef _LUP_CLASS_
#define _LUP_CLASS_

#include <math.h>
#include <vector>

class LUPMatrix {
  private:
    std::vector< std::vector<float> > value;
    std::vector< std::vector<float> > eulav;
    std::vector< std::vector<float> > LU;
    std::vector<int> P;
    int size;
    bool isDecomposed;
    bool isInverted;

    void invert() {
      if (!isDecomposed) decompose();

      for (int j = 0; j < size; j++) {
        for (int i = 0; i < size; i++) {
          if (P[i] == j) eulav[i][j] = 1.0;
          else eulav[i][j] = 0.0;

          for (int k = 0; k < i; k++) {
            eulav[i][j] = eulav[i][j] - LU[i][k] * eulav[k][j];
          }
        }

        for (int i = size - 1; i >= 0; i--) {
          for (int k = i + 1; k < size; k++) {
            eulav[i][j] = eulav[i][j] - LU[i][k] * eulav[k][j];
          }
          eulav[i][j] = eulav[i][j] / LU[i][i];
        }
      }
      isInverted = true;
    }

    void decompose() {
      for (int step = 0; step < size; step++) {
        float maxColVal = 0;
        int maxColValRow = step;

        for (int row = step; row < size; row++) {
          if (LU[row][step] > maxColVal) {
            maxColVal = LU[row][step];
            maxColValRow = row;
          }
        }

        // put col max value on diagonal
        if (maxColValRow != step) {
          int tp = P[step];
          P[step] = P[maxColValRow];
          P[maxColValRow] = tp;

          for (int ti = 0; ti < LU[step].size(); ti++) {
            float temp = LU[step][ti];
            LU[step][ti] = LU[maxColValRow][ti];
            LU[maxColValRow][ti] = temp;
          }

          P[size] += 1;
        }

        for (int row = step + 1; row < size; row++) {
          LU[row][step] = LU[row][step] / LU[step][step];

          for (int col = step + 1; col < size; col++) {
            LU[row][col] = LU[row][col] - LU[row][step] * LU[step][col];
          }
        }
      }
      isDecomposed = true;
    }

  public:
    LUPMatrix(int* input, int input_length) {
      size = ceil(sqrt(input_length));

      for (int i = 0; i < size; i++) {
        P.push_back(0);
        std::vector<float> row_value;
        std::vector<float> row_eulav;
        std::vector<float> row_LU;
        for (int j = 0; j < size; j++) {
          row_value.push_back(0.0);
          row_eulav.push_back(0.0);
          row_LU.push_back(0.0);
        }
        value.push_back(row_value);
        eulav.push_back(row_eulav);
        LU.push_back(row_LU);
      }
      P.push_back(0);
      set(input, input_length);
    }

    void set(int* input, int input_length) {
      for (int i = 0; i < size * size; i++) {
        value[i / size][i % size] = input[i % input_length];
        eulav[i / size][i % size] = input[i % input_length];
        LU[i / size][i % size] = input[i % input_length];
      }

      for (int i = 0; i < P.size(); i++) {
        P[i] = i;
      }

      isDecomposed = false;
      isInverted = false;
    }

    const std::vector< std::vector<float> >* inverted() {
      if (!isDecomposed) decompose();
      if (!isInverted) invert();
      return &eulav;
    }
};

#endif
