import java.nio.ByteBuffer;

public class Block {
  private int index_transactions;
  private int index_last_block_hash;
  private int index_target;
  private int index_nonce;

  private int target;
  private int nonce;

  private byte[] sha_input;
  private byte[] hash;

  private byte[] intToBytes(int i) {
    ByteBuffer bb = ByteBuffer.allocate(Integer.BYTES); 
    return bb.putInt(i).array();
  }

  public Block(byte[] data, byte[] h0, int t) {
    makeBlock(data, h0, t);
  }

  public Block(byte[] data, int t) {
    makeBlock(data, new byte[32], t);
  }

  public Block(byte[] data, byte[] h0) {
    makeBlock(data, h0, 0x7fffffff);
  }

  public Block(byte[] data) {
    makeBlock(data, new byte[32], 0x7fffffff);
  }

  public int nextTarget() {
    if (hash == null) hashMe();
    return ((0xff & hash[2]) << 24) | ((0xff & hash[3]) << 16);
  }

  public int nonce() {
    if (hash == null) hashMe();
    return nonce;
  }

  public byte[] hash() {
    if (hash == null) hashMe();
    return hash;
  }

  private void makeBlock(byte[] data, byte[] h0, int t) {
    sha_input = new byte[data.length + h0.length + Integer.BYTES + Integer.BYTES];
    target = t;
    nonce = 0;

    int copy_index = 0;
    index_transactions = copy_index;
    arraycopy(data, 0, sha_input, copy_index, data.length);
    copy_index += data.length;

    index_last_block_hash = copy_index;
    arraycopy(h0, 0, sha_input, copy_index, h0.length);
    copy_index += h0.length;

    index_target = copy_index;
    arraycopy(intToBytes(target), 0, sha_input, copy_index, Integer.BYTES);
    copy_index += Integer.BYTES;

    index_nonce = copy_index;
    arraycopy(intToBytes(nonce), 0, sha_input, copy_index, Integer.BYTES);
  }

  private void hashMe() {
    arraycopy(intToBytes(nonce), 0, sha_input, index_nonce, Integer.BYTES);
    hash = SHA256.encode(sha_input);

    while (!meetsTarget(hash)) {
      nonce += 1;
      arraycopy(intToBytes(nonce), 0, sha_input, index_nonce, Integer.BYTES);
      hash = SHA256.encode(sha_input);
    }

    println("done! target : " + String.format("%04x", target >>> 16));
    println("      nonce  : " + nonce);
    println("      hash   : " + this);
  }

  private boolean meetsTarget(byte[] h) {
    int one_byte = (0xff & h[0]);
    int two_bytes = (one_byte << 8) | (0xff & h[1]);
    return ((target >>> 16) ^ two_bytes) == 0;
  }

  public String toString() {
    if (hash == null) hashMe();
    String s = "";
    for (int i = 0; i < hash.length; i++) {
      s += String.format("%02x", hash[i]);
    }
    return s;
  }
}
