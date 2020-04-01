class PRNG {
  static final int SLENGTH = 256;  

  private int[] KEY;
  private int KEYLENGTH;
  private int[] S;
  private int I = 0;
  private int J = 0;

  public PRNG(int[] _KEY) {
    KEY = _KEY;
    KEYLENGTH = KEY.length;
    ksa();
  }

  private void ksa() {
    S = new int[SLENGTH];

    for (int i = 0; i < S.length; i++) {
      S[i] = i;
    }

    int j = 0;
    for (int i = 0; i < S.length; i++) {
      j = (j + S[i] + KEY[i % KEYLENGTH]) % S.length;
      int swap = S[i];
      S[i] = S[j];
      S[j] = swap;
    }
  }

  public int random() {
    I = (I + 1) % S.length;
    J = (J + S[I]) % S.length;
    int swap = S[I];
    S[I] = S[J];
    S[J] = swap;
    int K = S[(S[I] + S[J]) % S.length];
    return K;
  }
}
