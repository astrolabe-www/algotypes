static class Complex {
  public float real = 0;
  public float imag = 0;

  public Complex(float r, float i) {
    real = r;
    imag = i;
  }

  public Complex(Complex c) {
    real = c.real;
    imag = c.imag;
  }

  public float magnitude() {
    return sqrt(real * real + imag * imag);
  }

  static public Complex add(Complex c0, Complex c1) {
    return new Complex(c0.real + c1.real, c0.imag + c1.imag);
  }

  static public Complex subtract(Complex c0, Complex c1) {
    return new Complex(c0.real - c1.real, c0.imag - c1.imag);
  }

  static public Complex multiply(Complex c0, Complex c1) {
    return new Complex(c0.real * c1.real - c0.imag * c1.imag, c0.real * c1.imag + c0.imag * c1.real);
  }
}
