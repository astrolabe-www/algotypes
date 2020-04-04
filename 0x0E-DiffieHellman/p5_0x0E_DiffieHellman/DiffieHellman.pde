public class DiffieHellman {
  public int publicKey;
  public int partialKey;

  private int privateKey;
  private int fullKey;

  public DiffieHellman(int pub, int pvt) {
    publicKey = pub;
    privateKey = pvt;
  }

  public void generatePartialKey(int otherPublicKey) {
    int a = min(publicKey, otherPublicKey);
    int p = max(publicKey, otherPublicKey);
    partialKey = powmod(a, privateKey, p);
  }

  public void generateFullKey(int otherPartialKey, int otherPublicKey) {
    int p = max(publicKey, otherPublicKey);
    fullKey = powmod(otherPartialKey, privateKey, p);
  }

  // a ^ b % p
  private int powmod(int a, int b, int p) {
    if (a > p)
      a %= p;
    return pow_mod_rec(a, b, p);
  }

  private int pow_mod_rec(int a, int b, int p) {
    if (b == 1) return a;

    int t = pow_mod_rec(a, b >> 1, p);
    t = mul_mod(t, t, p);

    if ((b & 1) == 1) {
      t = mul_mod(t, a, p);
    }
    return t;
  }

  private int mul_mod(int a, int b, int p) {
    int result = 0;

    while (b != 0) {
      if ((b & 1) == 1) {
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

      b >>= 1;
    }
    return result;
  }
}
