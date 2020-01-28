import java.nio.ByteBuffer;

class Keccak {
  private final int L = 6;
  private final int WORD_LENGTH = (1 << 6);
  private final int WORD_LENGTH_BYTES = WORD_LENGTH / 8;
  private final int ROUNDS = 12 + 2 * L;
  private final byte SHA3_SUFFIX = 0x06;

  private int rate;
  private int rate_bytes;
  private int capacity;
  private int output_length_bytes;

  private ByteBuffer b2l_buffer = ByteBuffer.allocate(Long.BYTES);

  private Keccak(int r, int c) {
    rate = r;
    capacity = c;
    output_length_bytes = (capacity / 2) / 8;
    rate_bytes = rate / 8;
  }

  private long rotate64(long a, int n) {
    return (a << n) ^ (a >>> (64 - n));
  }

  private long[][] keccak_1600_lanes(long[][] lanes) {
    long R = 1L;
    long[] C = new long[5];

    for (int round = 0; round < ROUNDS; round++) {
      // θ
      for (int x = 0; x < 5; x++) {
        C[x] = lanes[x][0] ^ lanes[x][1] ^ lanes[x][2] ^ lanes[x][3] ^ lanes[x][4];
      }

      for (int x = 0; x < 5; x++) {
        long D = C[(x+4)%5] ^ rotate64(C[(x+1)%5], 1);
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
        y = (2*x_old+3*y)%5;
        current = lanes[x][y];
        lanes[x][y] = rotate64(current_old, (t+1)*(t+2)/2);
      }

      // χ
      for (y = 0; y < 5; y++) {
        long[] T = new long[5];
        for (x = 0; x < 5; x++) {
          T[x] = lanes[x][y];
        }
        for (x = 0; x < 5; x++) {
          lanes[x][y] = T[x] ^ ( (~T[(x+1)%5]) & T[(x+2)%5] );
        }
      }

      // ι
      for (int j = 0; j < 7; j++) {
        R = ((R << 1) ^ ((R >> 7) * 0x71)) % 256;
        if ((R & 2) != 0) {
          lanes[0][0] = lanes[0][0] ^ (1L << ((1<<j)-1));
        }
      }
    }
    return lanes;
  }

  private byte[] keccak_1600(byte[] state) {
    // turn bytes > longs
    long[][] lanes = new long[5][5];
    byte[] lane_bytes = new byte[WORD_LENGTH_BYTES];

    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        for (int b = 0; b < WORD_LENGTH_BYTES; b++) {
          lane_bytes[(WORD_LENGTH_BYTES - 1) - b] = state[WORD_LENGTH_BYTES * x + WORD_LENGTH_BYTES * 5 * y + b];
        }

        b2l_buffer.put(lane_bytes);
        b2l_buffer.flip();
        lanes[x][y] = b2l_buffer.getLong();
        b2l_buffer.clear();
      }
    }

    lanes = keccak_1600_lanes(lanes);

    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        b2l_buffer.putLong(lanes[x][y]);
        lane_bytes = b2l_buffer.array();

        for (int b = 0; b < WORD_LENGTH_BYTES; b++) {
          state[WORD_LENGTH_BYTES * x + WORD_LENGTH_BYTES * 5 * y + b] = lane_bytes[(WORD_LENGTH_BYTES - 1) - b];
        }
        b2l_buffer.clear();
      }
    }
    return state;
  }

  public byte[] SHA3(byte[] input) {
    byte[] output = new byte[output_length_bytes];

    byte[] state = new byte[(rate + capacity) / 8];
    for (int i = 0; i < state.length; i++) {
      state[i] = 0x00;
    }

    // absorb input 
    int block_size = 0;
    for (int b = 0; b < input.length; b += rate_bytes) {
      block_size = min(input.length - b, rate_bytes);

      for (int i = 0; i < block_size; i++) {
        state[i] = byte(state[i] ^ input[b + i]);
      }

      if (block_size == rate_bytes) {
        state = keccak_1600(state);
        block_size = 0;
      }
    }

    // padding of input
    state[block_size] = byte(state[block_size] ^ SHA3_SUFFIX);
    state[rate_bytes - 1] = byte(state[rate_bytes - 1] ^ 0x80);

    state = keccak_1600(state);

    // squeeeeze my output
    for (int b = 0; b < output_length_bytes; b += rate_bytes) {
      block_size = min(output_length_bytes - b, rate_bytes);

      for (int i = 0; i < block_size; i++) {
        output[b * block_size + i] = state[i];
      }

      if (block_size == rate_bytes) {
        state = keccak_1600(state);
      }
    }
    return output;
  }
}
