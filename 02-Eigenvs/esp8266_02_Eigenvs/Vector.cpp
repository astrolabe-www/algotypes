#include <math.h>
#include <vector>

#include "Vector.h"
#include "SquareMatrix.h"

float Vector::norm() {
  float norm_sum = 0;
  for (int i = 0; i < size; i++) {
    norm_sum += value[i] * value[i];
  }
  return sqrt(norm_sum);
}

Vector::Vector(int s) {
  size = s;
  std::vector<int> zero{0};
  set(zero);
}

void Vector::set(std::vector<int> input) {
  for (int i = 0; i < size; i++) {
    value.push_back((i < input.size()) ? input[i] : 0);
  }
}

float Vector::inner_product(Vector v, Vector w) {
  float sum = 0;
  for (int i = 0; i < v.size; i++) {
    sum += v.value[i] * w.value[i];
  }
  return sum;
}

Vector Vector::projection(Vector u, Vector a) {
  Vector result(u.size);

  float scaler =  Vector::inner_product(u, a) / Vector::inner_product(u, u);

  for (int i = 0; i < u.size; i++) {
    result.value[i] = scaler * u.value[i];
  }
  return result;
}

Vector Vector::add(Vector A, Vector B) {
  int result_size = std::min(A.size, B.size);
  Vector result(result_size);
  for (int i = 0; i < result_size; i++) {
    result.value[i] = A.value[i] + B.value[i];
  }
  return result;
}

Vector Vector::subtract(Vector A, Vector B) {
  int result_size = std::min(A.size, B.size);
  Vector result(result_size);
  for (int i = 0; i < result_size; i++) {
    result.value[i] = A.value[i] - B.value[i];
  }
  return result;
}

Vector Vector::normalized() {
  Vector result(size);
  float norm = this->norm();
  for (int i = 0; i < size; i++) {
    result.value[i] = value[i] / norm;
  }
  return result;
}

Vector Vector::multiply(SquareMatrix A, Vector B) {
  int result_size = std::min(A.size, B.size);
  Vector result(result_size);

  for (int i = 0; i < result_size; i++) {
    float sum = 0;
    for (int k = 0; k < result_size; k++) {
      sum += A.value[i][k] * B.value[k];
    }
    result.value[i] = sum;
  }
  return result;
}
