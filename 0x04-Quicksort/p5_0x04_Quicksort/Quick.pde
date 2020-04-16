static public class Quick {

  static public int[] sort(int[] input) {
    int output[] = input.clone();

    if (output.length > 1)
      quicksort(output, 0, output.length - 1);

    return output;
  }

  static private void quicksort(int[] input, int firstI, int lastI) {
    if (firstI >= lastI) return;

    int pivot = input[lastI];
    int tempV;

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
}
