public static class Primal {

  public static int[] primes(int[] in) {
    for (int i = 0; i < in.length; i++) {
      int np = nextPrime(in[i]);
      // println(String.format("%02d", in[i]) + " > " + String.format("%02d", np));
      in[i] = np;
    }
    return in;
  }

  private static boolean isPrime(int n) {
    if (n <= 3) return (n > 1);
    else if (((n % 2) == 0) || ((n % 3) == 0)) return false;

    for (int i = 6; (i*i) < n; i += 6) {
      if (((n % (i - 1)) == 0) || ((n % (i + 1)) == 0)) return false;
    }
    return true;
  }

  private static int next6k(int n) {
    for (int i = 0; i < 6; i++) {
      if (((n + i) % 6) == 0) return (n + i);
    }
    return (n + 6);
  }

  private static int nextPrime(int n) {
    if(isPrime(n)) return n;

    n = next6k(n);

    for (int i = n; i < 0x7fffffff; i += 6) {
      if (isPrime(i - 1)) return (i - 1);
      if (isPrime(i + 1)) return (i + 1);
    }
    return 0x7fffffff;
    // biggest 32-bit prime is 2 ^ 31 - 1, or 0x7fffffff
    // a big 64-bit prime is: 2^61 - 1, or 0x1fffffffffffffff
  }
}
