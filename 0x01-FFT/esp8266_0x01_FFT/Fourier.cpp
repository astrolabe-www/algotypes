#include <vector>
#include "Complex.cpp"

#define TWO_PI (2 * M_PI)

class Fourier {
  public:
    static std::vector<Complex> FFT(int* x, int xlength) {
      std::vector<Complex> x_complex;
      for (int i = 0; i < xlength; i++) {
        Complex c((float)(x[i]), 0.0);
        x_complex.push_back(c);
      }
      std::vector<Complex> fft = FFT(x_complex, 0, 1);
      return fft;
    }

    static std::vector<Complex> FFT(std::vector<Complex> x, int index, int stride) {
      int num_samples = x.size() / stride;
      int half_num_samples = num_samples >> 1;

      if (num_samples == 1) {
        std::vector<Complex> rComplex{ x[index] };
        return rComplex;
      } else {
        float TWO_PI_by_N = TWO_PI / num_samples;

        std::vector<Complex> F0 = FFT(x, index, 2 * stride);
        std::vector<Complex> F1 = FFT(x, index + stride, 2 * stride);
        std::vector<Complex> F;

        for (int i = 0; i < half_num_samples; i++) {
          F.push_back(F0[i]);
        }
        for (int i = 0; i < half_num_samples; i++) {
          F.push_back(F1[i]);
        }

        for (int k = 0; k < half_num_samples; k++) {
          Complex Fk = F[k];

          float angle = TWO_PI_by_N * k;
          Complex exp = Complex(cos(angle), -sin(angle));
          Complex F_k_next = F[k + half_num_samples];

          Complex x_k_n = Complex::multiply(exp, F_k_next);

          F[k] = Complex::add(Fk, x_k_n);
          F[k + half_num_samples] = Complex::subtract(Fk, x_k_n);
        }
        return F;
      }
    }
};
