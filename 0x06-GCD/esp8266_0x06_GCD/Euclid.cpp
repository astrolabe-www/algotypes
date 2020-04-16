#ifndef _EUCLID_CLASS_
#define _EUCLID_CLASS_

class Euclid {
  public:
    static int gcd(int a, int b) {
      if (b == 0) return a;
      else return gcd(b, a % b);
    }
};

#endif
