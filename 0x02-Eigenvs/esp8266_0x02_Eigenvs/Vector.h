#ifndef _VECTOR_CLASS_
#define _VECTOR_CLASS_

#include <vector>
class SquareMatrix;

class Vector {
  private:
    float norm();

  public:
    int size;
    std::vector<float> value;

    Vector(int s);
    void set(std::vector<int> input);

    Vector normalized();

    static Vector projection(Vector u, Vector a);
    static Vector add(Vector A, Vector B);
    static Vector subtract(Vector A, Vector B);
    static Vector multiply(SquareMatrix A, Vector B);
    static float inner_product(Vector v, Vector w);
};

#endif
