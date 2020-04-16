#ifndef _DIFFIEHELLMAN_CLASS_
#define _DIFFIEHELLMAN_CLASS_

#include <algorithm>

class DiffieHellman {
  private:
    int privateKey;
    int fullKey;

  public:
    int publicKey;
    int partialKey;

    DiffieHellman(int pub, int pvt) {
      publicKey = pub;
      privateKey = pvt;
    }

    int generatePartialKey(int otherPublicKey) {
      int a = std::min(publicKey, otherPublicKey);
      int p = std::max(publicKey, otherPublicKey);
      partialKey = powmod(a, privateKey, p);
      return partialKey;
    }

    int generateFullKey(int otherPartialKey, int otherPublicKey) {
      int p = std::max(publicKey, otherPublicKey);
      fullKey = powmod(otherPartialKey, privateKey, p);
      return fullKey;
    }

  private:
    // a ^ b % p
    int powmod(int a, int b, int p) {
      if (a > p)
        a = a % p;
      return pow_mod_rec(a, b, p);
    }

    int pow_mod_rec(int a, int b, int p) {
      if (b == 1) return a;

      int t = pow_mod_rec(a, b >> 1, p);
      t = mul_mod(t, t, p);

      if (b & 0x1) {
        t = mul_mod(t, a, p);
      }
      return t;
    }

    int mul_mod(int a, int b, int p) {
      int result = 0;

      while (b) {
        if (b & 0x1) {
          int nr = result + a;
          while ((nr >= p) || (nr < 0)) {
            result -= p;
            nr = result + a;
          }
          result = nr;
        }

        int ta = a;
        int na = ta + a;
        while ((na >= p) || (na < 0)) {
          ta -= p;
          na = ta + a;
        }
        a = na;

        b = b >> 1;
      }
      return result;
    }
};

#endif
