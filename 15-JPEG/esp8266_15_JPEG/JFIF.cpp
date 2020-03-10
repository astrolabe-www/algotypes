#ifndef _JFIF_CLASS_
#define _JFIF_CLASS_

#include <math.h>
#include <vector>

class JFIF {
  private:
    std::vector< std::vector<int> > LUMINANCE_QUANTIZATION = {
      {16, 11, 10, 16, 24, 40, 51, 61},
      {12, 12, 14, 19, 26, 28, 60, 55},
      {14, 13, 16, 24, 40, 57, 69, 56},
      {14, 17, 22, 29, 51, 87, 80, 62},
      {18, 22, 37, 56, 68, 109, 103, 77},
      {24, 35, 55, 64, 81, 104, 113, 92},
      {49, 64, 78, 87, 103, 121, 120, 101},
      {72, 92, 95, 98, 112, 100, 103, 99}
    };

    const int BLOCK_DIMENSION = 8;

    int size;
    std::vector< std::vector<int> > v_luminance;
    std::vector< std::vector<int> > v_jpegged;
    bool isJpegged;

    std::vector< std::vector<int> >* center_block(std::vector< std::vector<int> >* p, int v) {
      for (int i = 0; i < BLOCK_DIMENSION; i++) {
        for (int j = 0; j < BLOCK_DIMENSION; j++) {
          (*p)[i][j] = (*p)[i][j] - v;
        }
      }
      return p;
    }

    std::vector< std::vector<int> >* DCT_block(std::vector< std::vector<int> >* p) {
      std::vector< std::vector<int> > g;
      for (int v = 0; v < BLOCK_DIMENSION; v++) {
        std::vector<int> row;
        for (int u = 0; u < BLOCK_DIMENSION; u++) {
          row.push_back(0);
        }
        g.push_back(row);
      }

      float SQRT_2_2 = sqrt(2.0) / 2.0;

      for (int v = 0; v < BLOCK_DIMENSION; v++) {
        float a_v = (v == 0) ? SQRT_2_2 : 1;

        for (int u = 0; u < BLOCK_DIMENSION; u++) {
          float a_u = (u == 0) ? SQRT_2_2 : 1;
          float sum = 0;

          for (int y = 0; y < BLOCK_DIMENSION; y++) {
            float cos_y = cos((2 * y + 1) * v * M_PI / 16.0);
            for (int x = 0; x < BLOCK_DIMENSION; x++) {
              sum += (*p)[y][x] * cos((2 * x + 1) * u * M_PI / 16.0) * cos_y;
            }
          }
          g[v][u] = round(0.25 * a_v * a_u * sum);
        }
      }

      for (int v = 0; v < BLOCK_DIMENSION; v++) {
        for (int u = 0; u < BLOCK_DIMENSION; u++) {
          (*p)[v][u] = g[v][u];
        }
      }

      return p;
    }

    std::vector< std::vector<int> >* quantize_block(std::vector< std::vector<int> >* p, std::vector< std::vector<int> > q) {
      for (int i = 0; i < BLOCK_DIMENSION; i++) {
        for (int j = 0; j < BLOCK_DIMENSION; j++) {
          (*p)[i][j] = round((*p)[i][j] / q[i][j]);
        }
      }
      return p;
    }

  public:
    JFIF(int* input, int input_length) {
      size = ceil(sqrt(input_length));

      for (int i = 0; i < size; i++) {
        std::vector<int> row_v_luminance;
        std::vector<int> row_v_jpegged;
        for (int j = 0; j < size; j++) {
          row_v_luminance.push_back(0);
          row_v_jpegged.push_back(0);
        }
        v_luminance.push_back(row_v_luminance);
        v_jpegged.push_back(row_v_jpegged);
      }

      set(input, input_length);
    }

    void set(int* input, int input_length) {
      for (int i = 0; i < size * size; i++) {
        v_luminance[i / size][i % size] = input[i % input_length];
      }
      isJpegged = false;
    }


    const std::vector< std::vector<int> >* luminance() {
      return &v_luminance;
    }

    const std::vector< std::vector<int> >* jpeg() {
      if (isJpegged) return &v_jpegged;

      for (int yb = 0; yb < size; yb += BLOCK_DIMENSION) {
        for (int xb = 0; xb < size; xb += BLOCK_DIMENSION) {
          std::vector< std::vector<int> > block;

          for (int p = 0; p < BLOCK_DIMENSION; p++) {
            std::vector<int> row;
            for (int q = 0; q < BLOCK_DIMENSION; q++) {
              row.push_back(v_luminance[yb + p][xb + q]);
            }
            block.push_back(row);
          }

          std::vector< std::vector<int> >* quanted = center_block(quantize_block(DCT_block(center_block(&block, 128)), LUMINANCE_QUANTIZATION), -128);

          for (int p = 0; p < BLOCK_DIMENSION; p++) {
            for (int q = 0; q < BLOCK_DIMENSION; q++) {
              v_jpegged[yb + p][xb + q] = (*quanted)[p][q];
            }
          }
        }
      }

      isJpegged = true;
      return &v_jpegged;
    }
};

#endif
