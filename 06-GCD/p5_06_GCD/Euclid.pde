static public class Euclid {
  static public int gcd(int a, int b) {
    if (b == 0) return a;
    else return gcd(b, a % b);
  }
}
