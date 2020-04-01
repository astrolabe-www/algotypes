static public class Quick {

  static public int[] sort(int[] input) {
    int output[] = input.clone();

    if (output.length > 1)
      quicksort(output, 0, output.length - 1);

    return output;
  }

  static private void quicksort(int[] input, int firstI, int lastI) {
    int pivot = input[lastI];
    int leftI = firstI - 1;
    int tempV;

    for (int j = firstI; j < lastI; j++) {
      if (input[j] <= pivot) {
        tempV = input[++leftI];
        input[leftI] = input[j];
        input[j] = tempV;
      }
    }

    tempV = input[++leftI];
    input[leftI] = input[lastI];
    input[lastI] = tempV;

    if (firstI < (leftI - 1))
      if (isBetween(firstI, 0, input.length - 1) && isBetween(leftI - 1, 0, input.length - 1))
        quicksort(input, firstI, leftI - 1);

    if ((leftI + 1) < lastI)
      if (isBetween(leftI + 1, 0, input.length - 1) && isBetween(lastI, 0, input.length - 1))
        quicksort(input, leftI + 1, lastI);
  }

  static boolean isBetween(int v, int min, int max) {
    return (v >= min) && (v <= max);
  }
}
