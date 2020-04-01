#ifndef _BLOCK_CLASS_
#define _BLOCK_CLASS_

#include <vector>
#include <Arduino.h>
#include "SHA256.cpp"

class Block {
  private:
    int index_transactions;
    int index_last_block_hash;
    int index_target;
    int index_nonce;

    uint8_t target;
    uint32_t nonce;

    std::vector<uint8_t> sha_input;
    std::vector<uint8_t>* h0;
    std::vector<uint8_t>* hash;

    SHA256 mSHA256;

    bool meetsTarget(std::vector<uint8_t>* h) {
      return (((*h)[0] & 0x03) ==  (target & 0x03));
    }

    void hashMe() {
      for (int i = 0; i < sizeof(uint32_t); i++) {
        int bi = (sizeof(uint32_t) - 1) - i;
        sha_input[index_nonce + i] = (uint8_t)((nonce >> (8 * bi)) & 0xFF);
      }

      hash = mSHA256.encode(&sha_input);

      while (!meetsTarget(hash)) {
        nonce += 1;
        for (int i = 0; i < sizeof(uint32_t); i++) {
          int bi = (sizeof(uint32_t) - 1) - i;
          sha_input[index_nonce + i] = (uint8_t)((nonce >> (8 * bi)) & 0xFF);
        }
        hash = mSHA256.encode(&sha_input);
      }
    }

  public:
    Block(int* data, int data_length, std::vector<uint8_t>* _h0, uint8_t _t) {
      h0 = _h0;
      target = _t;
      makeBlock(data, data_length);
    }

    uint8_t getNextTarget() {
      if (hash == NULL) hashMe();
      return (*hash)[3];
    }

    std::vector<uint8_t>* getHash() {
      if (hash == NULL) hashMe();
      return hash;
    }

    void makeBlock(int* data, int data_length) {
      nonce = 0;
      hash = NULL;

      index_transactions = sha_input.size();
      for (int i = 0; i < data_length; i++) sha_input.push_back(data[i]);

      index_last_block_hash = sha_input.size();
      for (int i = 0; i < h0->size(); i++) sha_input.push_back((*h0)[i]);

      index_nonce = sha_input.size();
      for (int i = 0; i < sizeof(uint32_t); i++) {
        int bi = (sizeof(uint32_t) - 1) - i;
        sha_input.push_back((uint8_t)((nonce >> (8 * bi)) & 0xFF));
      }

      index_target = sha_input.size();
      sha_input.push_back(target);
    }
};

#endif
