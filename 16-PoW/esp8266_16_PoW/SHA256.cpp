#ifndef _SHA_CLASS_
#define _SHA_CLASS_

#include <vector>
#include <Arduino.h>

class SHA256 {
  private:
    std::vector<uint32_t> K = {
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    };

    std::vector<uint32_t> H0 = {
      0x6a09e667,
      0xbb67ae85,
      0x3c6ef372,
      0xa54ff53a,
      0x510e527f,
      0x9b05688c,
      0x1f83d9ab,
      0x5be0cd19
    };

    int rightrotate(uint32_t w, int n) {
      return ((w << (32 - n)) | (w >> n));
    }

    std::vector<uint8_t> out;

  public:
    std::vector<uint8_t>* encode(int* in, int in_length) {
      out.clear();

      std::vector<uint32_t> H;
      for (int i = 0; i < H0.size(); i++) {
        H.push_back(H0[i]);
      }

      uint32_t L = in_length * 8;

      // padding: L + 64 + Kb must be multiple of 512 bits
      int Kb = 512 - ((L + 64) % 512);

      std::vector<uint8_t> in_bytes;
      for (int i = 0; i < in_length; i++) {
        in_bytes.push_back(in[i]);
      }
      for (int i = 0; i < (Kb / 8 + 64 / 8); i++) {
        in_bytes.push_back(0x00);
      }

      int in_index = in_length;
      for (int i = 0; i < Kb / 8; i++) {
        uint8_t b = (uint8_t)((i == 0) ? 0x80 : 0x00);
        in_bytes[in_index] = b;
        in_index++;
      }

      in_index += 4;
      for (int i = 3; i >= 0; i--) {
        uint8_t b = (uint8_t)(0xff & (L >> (8 * i)));
        in_bytes[in_index] = b;
        in_index++;
      }

      // 512-bit chunks
      for (int c = 0; c < (in_bytes.size() * 8) / 512; c++) {
        int current_in_byte = c * 512 / 8;

        std::vector<uint8_t> word;
        for (int i = 0; i < 64; i++) {
          word.push_back(0);
        }

        std::vector<uint8_t> A;
        for (int i = 0; i < H.size(); i++) {
          A.push_back(0);
        }

        for (int w = 0; w < 16; w++) {
          int current_word_byte = current_in_byte + 4 * w;
          int mWord = 0x00;

          for (int b = 0; b < 4; b++) {
            mWord |= ((in_bytes[current_word_byte + b] & 0xff) << (8 * (3 - b)));
          }
          word[w] = mWord;
        }

        for (int w = 16; w < 64; w++) {
          int s0 = rightrotate(word[w - 15], 7) ^ rightrotate(word[w - 15], 18) ^ (word[w - 15] >>  3);
          int s1 = rightrotate(word[w - 2], 17) ^ rightrotate(word[w - 2], 19) ^ (word[w - 2] >>  10);
          word[w] = word[w - 16] + s0 + word[w - 7] + s1;
        }

        for (int i = 0; i < A.size(); i++) {
          A[i] = H[i];
        }

        for (int i = 0; i < 64; i++) {
          int s0 = rightrotate(A[4], 6) ^ rightrotate(A[4], 11) ^ rightrotate(A[4], 25);
          int ch = (A[4] & A[5]) ^ ((~A[4]) & A[6]);
          int temp0 = A[7] + s0 + ch + K[i] + word[i];

          int s1 = rightrotate(A[0], 2) ^ rightrotate(A[0], 13) ^ rightrotate(A[0], 22);
          int maj = (A[0] & A[1]) ^ (A[0] & A[2]) ^ (A[1] & A[2]);
          int temp1 = s1 + maj;

          A[7] = A[6];
          A[6] = A[5];
          A[5] = A[4];
          A[4] = A[3] + temp0;
          A[3] = A[2];
          A[2] = A[1];
          A[1] = A[0];
          A[0] = temp0 + temp1;
        }

        for (int h = 0; h < H.size(); h++) {
          H[h] = H[h] + A[h];
        }
      }

      for (int i = 0; i < H.size(); i++) {
        for (int b = 0; b < sizeof(uint32_t); b++) {
          uint8_t ov = (uint8_t)((H[i] >> (8 * (7 - b))) & 0xFF);
          out.push_back(ov);
        }
      }
      return &out;
    }
};

#endif
