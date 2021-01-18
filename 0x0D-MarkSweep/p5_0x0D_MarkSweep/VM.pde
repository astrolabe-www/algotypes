class VM {
  private final int MAX_STACK_SIZE = 256;
  private final int MAX_MEM_SIZE = 8 * MAX_STACK_SIZE;

  Thing[] mStack;
  Thing[] mMem;
  int mStackSize;
  int mMemSize;

  int cntP, cntI, cntMS;

  public VM() {
    randomSeed(1010);
    mStack = new Thing[MAX_STACK_SIZE];
    mMem = new Thing[MAX_MEM_SIZE];

    for (int i = 0; i < mStack.length; i++) mStack[i] = null;
    for (int i = 0; i < mMem.length; i++) mMem[i] = null;

    mStackSize = 0;
    mMemSize = 0;
    cntP = 0;
    cntI = 0;
    cntMS = 0;
  }

  public boolean step(int in) {
    if (in > random(0, 0xff)) {
      // pushInt(in);
      pushPair();
    } else {
      pushInt(in);
    }
    return (mStackSize >= MAX_STACK_SIZE);
  }

  public void markSweep() {
    while (mStackSize >= MAX_STACK_SIZE) {
      int mSum = 0;
      boolean stillPoping = true;

      // pop stuff and turn pairs into ints by adding towards other ints (random. I know.)
      while (stillPoping) {
        //for(int j = 0; j < (in + 1); j++) {
        Thing pThing = pop();
        if (pThing == null) break;

        if (pThing.type == ThingType.INT) {
          mSum += pThing.value;
        } else {
          if (pThing.one.type == ThingType.INT) {
            mSum += pThing.one.value;
            stillPoping = false;
          }
          if (pThing.two.type == ThingType.INT) {
            mSum += pThing.two.value;
            stillPoping = false;
          }
          if (!stillPoping) pushInt((mSum & 0xFF));
        }
      }
      printStats();
      mark();
      sweep();
      cntMS++;
      printStats();
      println();
    }
  }

  private void push(Thing mT) {
    if (mStackSize >= MAX_STACK_SIZE) return;
    mStack[mStackSize++] = mT;
    if (mT.type == ThingType.INT) cntI++;
    else if (mT.type == ThingType.PAIR) cntP++;
  }

  private Thing pop() {
    if (mStackSize <= 0) return null;
    Thing mT = mStack[--mStackSize];
    mStack[mStackSize] = null;
    if (mT.type == ThingType.INT) cntI--;
    else if (mT.type == ThingType.PAIR) cntP--;
    return mT;
  }

  private int findMemIndex() {
    for (int i = 0; i < mMem.length; i++) if (mMem[i] == null) return i;
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
    println(mStackSize + " ints: " + cntI + " & pairs: " + cntP + " mem: " + mMemSize + " M&Ss: " + cntMS);
  }
}
