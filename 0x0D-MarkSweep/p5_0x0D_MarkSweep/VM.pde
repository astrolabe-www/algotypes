class VM {
  private final int MAX_STACK_SIZE = 256;
  private final int MAX_FIELD_SIZE = 4 * MAX_STACK_SIZE;
  private final int MAX_MEM_SIZE = 2 * MAX_FIELD_SIZE;
  private final int FIELDS_PER_MEM = (MAX_MEM_SIZE / MAX_FIELD_SIZE);

  private Thing[] mStack;
  private Thing[] mMem;
  private byte[] mField;

  private int mStackSize;
  private int mMemSize;

  public VM() {
    randomSeed(1010);
    mStack = new Thing[MAX_STACK_SIZE];
    mMem = new Thing[MAX_MEM_SIZE];
    mField = new byte[MAX_FIELD_SIZE];

    for (int i = 0; i < mStack.length; i++) mStack[i] = null;
    for (int i = 0; i < mMem.length; i++) mMem[i] = null;
    for (int i = 0; i < mField.length; i++) mField[i] = 0;

    mStackSize = 0;
    mMemSize = 0;
  }

  public byte[] step(int in) {
    pushInt(in);
    if (in > random(0, 0xff)) {
      pushPair();
    }

    if (mStackSize >= MAX_STACK_SIZE) {
      for (int i = 0; i < in; i++) pop();
    }

    if (needsMarkSweep()) prepareField();
    return mField;
  }

  public boolean needsMarkSweep() {
    return (mMemSize >= 3 * MAX_MEM_SIZE / 4);
  }

  public byte[] markSweep() {
    mark();
    sweep();
    return prepareField();
  }

  private byte[] prepareField() {
    for (int i = 0; i < mField.length; i++) mField[i] = 0;

    for (int i = 0; i < mMem.length; i++) {
      if (mMem[i] != null) {
        mField[i % mField.length] += (0xff / FIELDS_PER_MEM);
      }
    }
    return mField;
  }

  private void push(Thing mT) {
    if (mStackSize >= MAX_STACK_SIZE) return;
    mStack[mStackSize++] = mT;
  }

  private Thing pop() {
    if (mStackSize <= 0) return null;
    Thing mT = mStack[--mStackSize];
    mStack[mStackSize] = null;
    return mT;
  }

  private int findMemIndex() {
    for (int i = 0; i < mMem.length; i++) {
      int mi = (mMemSize + i) % mMem.length;
      if (mMem[mi] == null) return mi;
    }
    return mMem.length;
  }

  private void pushInt(int mi) {
    if (mMemSize >= MAX_MEM_SIZE) return;

    int ni = findMemIndex();

    mMem[ni] = new Thing(ThingType.INT);
    mMem[ni].value = mi;
    mMemSize++;

    push(mMem[ni]);
  }

  private void pushPair() {
    if (mMemSize >= MAX_MEM_SIZE) return;

    int ni = findMemIndex();

    mMem[ni] = new Thing(ThingType.PAIR);
    mMem[ni].one = pop();
    mMem[ni].two = pop();
    mMemSize++;

    if (mMem[ni].two == null) mMem[ni].two = mMem[ni].one;
    if (mMem[ni].one != null && mMem[ni].two != null) push(mMem[ni]);
  }

  private void mark() {
    for (int i = 0; i < mStackSize; i++) mStack[i].mark();
  }

  private void sweep() {
    for (int i = 0; i < mMem.length; i++) {
      if (mMem[i] != null && mMem[i].marked) {
        mMem[i].marked = false;
      } else if (mMem[i] != null) {
        mMem[i] = null;
        mMemSize--;
      }
    }
  }

  private void printStats() {
    println("stack: " + mStackSize + " mem: " + mMemSize);
  }
}
