#ifndef _COMPLEX_CLASS_
#define _COMPLEX_CLASS_

#include <math.h>

class Complex {
  public:
    float real = 0;
    float imag = 0;

    Complex(float r, float i) {
      real = r;
      imag = i;
    }

    Complex(const Complex &c) {
      real = c.real;
      imag = c.imag;
    }

    float magnitude() {
      return sqrt(this->real * this->real + this->imag * this->imag);
    }

    static Complex add(Complex &c0, Complex &c1) {
      Complex rComplex(c0.real + c1.real, c0.imag + c1.imag);
      return rComplex;
    }

    static Complex subtract(Complex &c0, Complex &c1) {
      Complex rComplex(c0.real - c1.real, c0.imag - c1.imag);
      return rComplex;
    }

    static Complex multiply(Complex &c0, Complex &c1) {
      Complex rComplex(c0.real * c1.real - c0.imag * c1.imag, c0.real * c1.imag + c0.imag * c1.real);
      return rComplex;
    }
};
#endif
