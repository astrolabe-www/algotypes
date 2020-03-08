class PRNG {
    static const int SLENGTH = 256;

    int* KEY;
    int KEYLENGTH;
    int S[SLENGTH];
    int I = 0;
    int J = 0;

    void ksa() {
      for (int i = 0; i < SLENGTH; i++) {
        S[i] = i;
      }

      int j = 0;
      for (int i = 0; i < SLENGTH; i++) {
        j = (j + S[i] + KEY[i % KEYLENGTH]) % SLENGTH;
        int swap = S[i];
        S[i] = S[j];
        S[j] = swap;
      }
    }

  public:
    PRNG(int* key, int kl) {
      KEY = key;
      KEYLENGTH = kl;
      ksa();
    }

    int random() {
      I = (I + 1) % SLENGTH;
      J = (J + S[I]) % SLENGTH;
      int swap = S[I];
      S[I] = S[J];
      S[J] = swap;
      int K = S[(S[I] + S[J]) % SLENGTH];
      return K;
    }
};
