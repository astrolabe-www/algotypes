#ifndef _QUICK_CLASS_
#define _QUICK_CLASS_

#include <Arduino.h>

class Quick {
  public:
    static void sort(int* input, int input_length, uint8_t* output) {
      for (int i = 0; i < input_length; i++) output[i] = (uint8_t)(input[i] & 0xFF);

      if (input_length > 1)
        quicksort(output, 0, input_length - 1);
    }

  private:
    static void quicksort(uint8_t* input, int firstI, int lastI) {
      if (firstI >= lastI) return;

      uint8_t pivot = input[lastI];
      uint8_t tempV;

      int leftI = firstI;
      int rightI = lastI;

      while (leftI <= rightI) {
        while (input[leftI] < pivot) leftI += 1;
        while (input[rightI] > pivot) rightI -= 1;
        if (leftI <= rightI) {
          tempV = input[leftI];
          input[leftI] = input[rightI];
          input[rightI] = tempV;
          leftI += 1;
          rightI -= 1;
        }
      }

      quicksort(input, firstI, rightI);
      quicksort(input, leftI, lastI);
    }

    static bool isBetween(int v, int min, int max) {
      return (v >= min) && (v <= max);
    }
};

#endif
