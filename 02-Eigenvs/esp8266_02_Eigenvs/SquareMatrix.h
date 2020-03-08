#ifndef _MATRIX_CLASS_
#define _MATRIX_CLASS_

#include <vector>
#include "Vector.h"

class SquareMatrix {
  private:
    Vector get_column(int j);
    void set_column(int j, Vector v);

  public:
    int size;
    std::vector< std::vector<float> > value;

    SquareMatrix(int s);
    SquareMatrix(int* input, int s);
    void set(std::vector<int> input);

    static SquareMatrix multiply(SquareMatrix A, SquareMatrix B);

    SquareMatrix transpose();
    SquareMatrix Q();
    SquareMatrix R();
    SquareMatrix QR();
};

#endif
