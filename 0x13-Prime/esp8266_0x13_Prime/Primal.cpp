#ifndef _PRIMAL_CLASS_
#define _PRIMAL_CLASS_

#include <vector>
#include <Arduino.h>

class Primal {
  public:
    static bool isPrime(int n) {
      if (n <= 3) return (n > 1);
      else if (((n % 2) == 0) || ((n % 3) == 0)) return false;

      for (int i = 6; (i * i) < n; i += 6) {
        if (((n % (i - 1)) == 0) || ((n % (i + 1)) == 0)) return false;
      }
      return true;
    }

    Primal(int* in, int in_length) {
      for (int i = 0; i < in_length / BYTES_PER_PRIME; i++) {
        int tn = 0x00;
        for (int b = 0; b < BYTES_PER_PRIME; b++) {
          int bi = (BYTES_PER_PRIME * i + b);
          tn = tn | ((in[bi] & 0xff) << (8 * (BYTES_PER_PRIME - 1 - b)));
        }

        int np = nextPrime(tn);
        for (int b = BYTES_PER_PRIME - 1; b > -1; b--) {
          mPrimes.push_back((uint8_t)((np >> (8 * b)) & 0xFF));
        }
      }
    }

    const std::vector<uint8_t>* primes() {
      return &mPrimes;
    }

  private:
    std::vector<uint8_t> mPrimes;
    const int BYTES_PER_PRIME = 2;

    int next6k(int n) {
      for (int i = 0; i < 6; i++) {
        if (((n + i) % 6) == 0) return (n + i);
      }
      return (n + 6);
    }

    int nextPrime(int n) {
      if (isPrime(n)) return n;
      if (n == 0) return 2;
      if (n == 0x7fffffff) return n;

      n = next6k(n);

      for (int i = n; i < 0x7fffffff; i += 6) {
        if (isPrime(i - 1)) return (i - 1);
        if (isPrime(i + 1)) return (i + 1);
      }
      return 0x7fffffff;
      // biggest 32-bit prime is 2 ^ 31 - 1, or 0x7fffffff
      // a big 64-bit prime is: 2^61 - 1, or 0x1fffffffffffffff
    }
};

#endif
