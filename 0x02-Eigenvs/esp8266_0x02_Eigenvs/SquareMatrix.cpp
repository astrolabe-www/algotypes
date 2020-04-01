#include <math.h>

#include "Vector.h"
#include "SquareMatrix.h"

Vector SquareMatrix::get_column(int j) {
  Vector result(size);
  for (int i = 0; i < size; i++) {
    result.value[i] = value[i][j];
  }
  return result;
}

void SquareMatrix::set_column(int j, Vector v) {
  for (int i = 0; i < size; i++) {
    value[i][j] = v.value[i];
  }
}

SquareMatrix::SquareMatrix(int s) {
  size = s;
  std::vector<int> zero{0};
  set(zero);
}

SquareMatrix::SquareMatrix(int* input, int s) {
  std::vector<int> inv;
  for (int i = 0; i < s; i++) {
    inv.push_back(input[i]);
  }
  size = ceil(sqrt(inv.size()));
  set(inv);
}

void SquareMatrix::set(std::vector<int> input) {
  for (int i = 0; i < size; i++) {
    std::vector<float> row;
    for (int j = 0; j < size; j++) {
      row.push_back(((i * size + j) < input.size()) ? input[i * size + j] : 0);
    }
    value.push_back(row);
  }
}

SquareMatrix SquareMatrix::multiply(SquareMatrix A, SquareMatrix B) {
  int result_size = std::min(A.size, B.size);
  SquareMatrix result(result_size);

  for (int i = 0; i < result_size; i++) {
    for (int j = 0; j < result_size; j++) {
      float sum = 0;
      for (int k = 0; k < result_size; k++) {
        sum += A.value[i][k] * B.value[k][j];
      }
      result.value[i][j] = sum;
    }
  }
  return result;
}

SquareMatrix SquareMatrix::transpose() {
  SquareMatrix result(size);
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      result.value[i][j] = value[j][i];
    }
  }
  return result;
}


SquareMatrix SquareMatrix::Q() {
  SquareMatrix U(size);

  for (int k = 0; k < size; k++) {
    Vector ak = get_column(k);

    Vector sum(size);
    for (int j = 0; j < k; j++) {
      sum = Vector::add(sum, Vector::projection(U.get_column(j), ak));
    }

    U.set_column(k, Vector::subtract(ak, sum));
  }

  for (int j = 0; j < size; j++) {
    U.set_column(j, U.get_column(j).normalized());
  }

  return U;
}

SquareMatrix SquareMatrix::R() {
  return SquareMatrix::multiply(Q().transpose(), *this);
}

SquareMatrix SquareMatrix::QR() {
  SquareMatrix Ak(size);
  for (int i = 0; i < size * size; i++) {
    Ak.value[i / size][i % size] = value[i / size][i % size];
  }

  for (int iteration = 0; iteration < 2; iteration++) {
    Ak = SquareMatrix::multiply(Ak.R(), Ak.Q());
  }
  return Ak;
}
