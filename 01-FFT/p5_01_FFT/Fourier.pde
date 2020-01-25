import java.util.Arrays;

static class Fourier {

  static public void testFTs(Complex[] FT0, Complex[] FT1) {
    for (int i = 0; i < min(FT0.length, FT1.length); i++) {
      float diff = abs(FT0[i].magnitude() / FT0.length - FT1[i].magnitude() / FT1.length);

      if (diff > 0.001) {
        println("mag[" + i + "] : " + diff);
      }
    }
  }

  static public Complex[] DFT(int[] x) {
    Complex[] F = new Complex[x.length / 2];

    float TWO_PI_by_N = TWO_PI/x.length;

    for (int k = 0; k < F.length; k++) {
      F[k] = new Complex(0, 0);

      float TWO_PI_by_N_k = TWO_PI_by_N * k;

      for (int n = 0; n < x.length; n++) {
        float angle = TWO_PI_by_N_k * n;
        Complex x_k_n = new Complex(x[n] * cos(angle), -x[n] * sin(angle));
        F[k] = Complex.add(F[k], x_k_n);
      }
    }
    return F;
  }

  static public Complex[] FFT(int[] x) {
    Complex[] x_complex = new Complex[x.length];
    for (int i = 0; i < x_complex.length; i++) {
      x_complex[i] = new Complex(x[i], 0);
    }
    return Arrays.copyOfRange(FFT(x_complex, 0, 1), 0, x_complex.length / 2);
  }

  static private Complex[] FFT(Complex[] x, int index, int stride) {
    int num_samples = x.length / stride;
    int half_num_samples = num_samples >> 1;

    if (num_samples == 1) {
      return (new Complex[]{x[index]});
    } else {
      float TWO_PI_by_N = TWO_PI / num_samples;

      Complex[] F0 = FFT(x, index, 2 * stride);
      Complex[] F1 = FFT(x, index + stride, 2 * stride);
      Complex[] F = new Complex[num_samples];

      for (int i = 0; i < half_num_samples; i++) {
        F[i] = F0[i];
        F[half_num_samples + i] = F1[i];
      }

      for (int k = 0; k < half_num_samples; k++) {
        Complex Fk = F[k];

        float angle = TWO_PI_by_N * k;
        Complex exp = new Complex(cos(angle), -sin(angle));
        Complex F_k_next = F[k + half_num_samples];

        Complex x_k_n = Complex.multiply(exp, F_k_next);

        F[k] = Complex.add(Fk, x_k_n);
        F[k + half_num_samples] = Complex.subtract(Fk, x_k_n);
      }
      return F;
    }
  }
}
