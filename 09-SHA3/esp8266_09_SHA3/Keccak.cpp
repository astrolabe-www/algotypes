#ifndef _KECCAK_CLASS_
#define _KECCAK_CLASS_

#include <vector>
#include <Arduino.h>

class Keccak {
  private:
    const int L = 5;
    const int WORD_LENGTH = (1 << L);
    const int WORD_LENGTH_BYTES = WORD_LENGTH / 8;
    const int ROUNDS = 12 + 2 * L;
    const byte SHA3_SUFFIX = 0x06;

    int rate;
    int rate_bytes;
    int capacity;
    int output_length_bytes;

    unsigned long rotate8L(unsigned long a, unsigned int n) {
      return (a << n) ^ (a >> (WORD_LENGTH - n));
    }

    void keccak_1600_lanes(std::vector< std::vector<long> > &lanes) {
      long R = 1L;

      for (int round = 0; round < ROUNDS; round++) {
        // θ
        std::vector<long> C;
        for (int x = 0; x < 5; x++) {
          C.push_back(lanes[x][0] ^ lanes[x][1] ^ lanes[x][2] ^ lanes[x][3] ^ lanes[x][4]);
        }

        for (int x = 0; x < 5; x++) {
          long D = C[(x + 4) % 5] ^ rotate8L(C[(x + 1) % 5], 1);
          for (int y = 0; y < 5; y++) {
            lanes[x][y] = lanes[x][y] ^ D;
          }
        }

        // ρ and π
        int x = 1;
        int y = 0;
        long current = lanes[x][y];
        for (int t = 0; t < 24; t++) {
          int x_old = x;
          long current_old = current;
          x = y;
          y = (2 * x_old + 3 * y) % 5;
          current = lanes[x][y];
          lanes[x][y] = rotate8L(current_old, (t + 1) * (t + 2) / 2);
        }

        // χ
        for (y = 0; y < 5; y++) {
          std::vector<long> T;
          for (x = 0; x < 5; x++) {
            T.push_back(lanes[x][y]);
          }
          for (x = 0; x < 5; x++) {
            lanes[x][y] = T[x] ^ ( (~T[(x + 1) % 5]) & T[(x + 2) % 5] );
          }
        }

        // ι
        for (int j = 0; j < 7; j++) {
          R = ((R << 1) ^ ((R >> 7) * 0x71)) % 256;
          if ((R & 2) != 0) {
            lanes[0][0] = lanes[0][0] ^ (1L << ((1 << j) - 1));
          }
        }
      }
    }

    void keccak_1600(std::vector<byte> &state) {
      // turn bytes > longs
      std::vector< std::vector<long> > lanes;
      for (int i = 0; i < 5; i++) {
        std::vector<long> row;
        for (int j = 0; j < 5; j++) {
          row.push_back(0);
        }
        lanes.push_back(row);
      }

      std::vector<byte> lane_bytes;
      for (int i = 0; i < WORD_LENGTH_BYTES; i++) {
        lane_bytes.push_back(0x00);
      }

      for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
          for (int b = 0; b < WORD_LENGTH_BYTES; b++) {
            lane_bytes[(WORD_LENGTH_BYTES - 1) - b] = state[WORD_LENGTH_BYTES * x + WORD_LENGTH_BYTES * 5 * y + b];
          }

          unsigned long lane_long = 0x00000000;
          for (int b = 0; b < WORD_LENGTH_BYTES; b++) {
            lane_long = (lane_long << 8) | lane_bytes[b];
          }
          lanes[x][y] = lane_long;
        }
      }

      keccak_1600_lanes(lanes);

      for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
          for (int b = 0; b < WORD_LENGTH_BYTES; b++) {
            lane_bytes[(WORD_LENGTH_BYTES - 1) - b] = (byte)((lanes[x][y] >> (8 * b)) & 0xFF);
            state[WORD_LENGTH_BYTES * x + WORD_LENGTH_BYTES * 5 * y + b] = lane_bytes[(WORD_LENGTH_BYTES - 1) - b];
          }
        }
      }
    }

  public:
    Keccak(int r, int c) {
      rate = r;
      capacity = c;
      output_length_bytes = (capacity / 2) / 8;
      rate_bytes = rate / 8;
    }

    std::vector<byte> SHA3(int* input, int input_length) {
      std::vector<byte> output;
      for (int i = 0; i < output_length_bytes; i++) {
        output.push_back(0x00);
      }

      std::vector<byte> state;
      for (int i = 0; i < ((rate + capacity) / 8); i++) {
        state.push_back(0x00);
      }

      // absorb input
      int block_size = 0;
      for (int b = 0; b < input_length; b += rate_bytes) {
        block_size = std::min(input_length - b, rate_bytes);

        for (int i = 0; i < block_size; i++) {
          state[i] = byte(state[i] ^ input[b + i]);
        }

        if (block_size == rate_bytes) {
          keccak_1600(state);
          block_size = 0;
        }
      }

      // padding of input
      state[block_size] = (byte)(state[block_size] ^ SHA3_SUFFIX);
      state[rate_bytes - 1] = (byte)(state[rate_bytes - 1] ^ 0x80);

      keccak_1600(state);

      // squeeeeze my output
      for (int b = 0; b < output_length_bytes; b += rate_bytes) {
        block_size = std::min(output_length_bytes - b, rate_bytes);

        for (int i = 0; i < block_size; i++) {
          output[b * block_size + i] = state[i];
        }

        if (block_size == rate_bytes) {
          keccak_1600(state);
        }
      }
      return output;
    }
};

#endif
