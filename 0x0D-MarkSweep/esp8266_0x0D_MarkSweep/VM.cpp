#ifndef _VM_CLASS_
#define _VM_CLASS_

#include <vector>

class VM {
  private:
    std::vector<int> mem;
    std::vector<bool> marked;

    void impute() {
      int newDataIndex = 0;
      for (newDataIndex = 0; newDataIndex < mem.size(); newDataIndex++) {
        if (mem[newDataIndex] % 256 != 0) break;
      }
      if (newDataIndex >= mem.size()) return;

      for (int i = 0; i < mem.size(); i++) {
        if (mem[i] % 256 == 0) {
          mem[i] = mem[newDataIndex];
          newDataIndex = (newDataIndex + 1) % mem.size();
          while (mem[newDataIndex] % 256 == 0) {
            newDataIndex = (newDataIndex + 1) % mem.size();
          }
        }
      }
    }

    void mark() {
      for (int i = 0; i < mem.size(); i++) {
        int block = i / 256;
        marked[block * 256 + mem[i]] = true;
      }
    }

    int sweep() {
      int markCount = 0;
      for (int i = 0; i < marked.size(); i++) {
        markCount += marked[i] ? 1 : 0;
        mem[i] = marked[i] ? mem[i] : 0;
        marked[i] = false;
      }
      return markCount;
    }

  public:
    VM(int* input, int input_length) {
      marked.reserve(input_length);
      mem.reserve(input_length);
      for (int i = 0; i < input_length; i++) {
        mem.push_back(input[i] & 0xFF);
        marked.push_back(false);
      }
      impute();
    }

    void markAndSweep() {
      mark();
      sweep();
    }

    int at(int i) {
      if (i < 0) i = -i;
      return mem[i % mem.size()];
    }
};

#endif
