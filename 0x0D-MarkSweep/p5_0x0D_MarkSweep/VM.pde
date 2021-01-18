class VM {
  private final int MAX_STACK_SIZE = 256;

  int mSize;
  Thing[] mStack;
  Thing firstThing;
  int cntP, cntI, cntMS;

  public VM() {
    randomSeed(1010);
    mStack = new Thing[MAX_STACK_SIZE];
    for (int i = 0; i < mStack.length; i++) mStack[i] = null;
    mSize = 0;
    cntP = 0;
    cntI = 0;
    cntMS = 0;
    firstThing = null;
  }

  public void step(int in) {
    if (in > random(0, 0xff)) {
      // pushInt(in);
      pushPair();
    } else {
      pushInt(in);
    }

    while (mSize >= MAX_STACK_SIZE) {
      int mSum = in;
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

  private void push(Thing t) {
    if (mSize >= MAX_STACK_SIZE) return;
    mStack[mSize++] = t;
    t.next = firstThing;
    firstThing = t;
    if (t.type == ThingType.INT) cntI++;
    else if (t.type == ThingType.PAIR) cntP++;
  }

  private Thing pop() {
    if (mSize <= 0) return null;
    Thing mT = mStack[--mSize];
    mStack[mSize] = null;
    if (mT.type == ThingType.INT) cntI--;
    else if (mT.type == ThingType.PAIR) cntP--;
    return mT;
  }

  private Thing head() {
    if (mSize <= 0) return null;
    return mStack[mSize - 1];
  }

  private void pushInt(int mi) {
    Thing mT = new Thing(ThingType.INT);
    mT.value = mi;
    push(mT);
  }

  private void pushPair() {
    Thing mT = new Thing(ThingType.PAIR);
    mT.one = pop();
    mT.two = pop();
    if (mT.two == null) mT.two = mT.one;
    if (mT.one != null && mT.two != null) push(mT);
  }

  private void mark() {
    for (int i = 0; i < mSize; i++) {
      mStack[i].mark();
    }
  }

  private void sweep() {
    Thing prevThing = null;
    Thing thisThing = firstThing;

    while (thisThing != null) {
      if (thisThing.marked) {
        thisThing.marked = false;
        prevThing = thisThing;
        thisThing = thisThing.next;
      } else {
        if (prevThing == null) {
          firstThing = thisThing.next;
          thisThing.next = null;
          thisThing = firstThing;
        } else {
          prevThing.next = thisThing.next;
          thisThing.next = null;
          thisThing = prevThing.next;
        }
      }
    }
  }

  private int countThings() {
    Thing thisThing = firstThing;
    int cnt = 0;
    while (thisThing != null) {
      cnt++;
      thisThing = thisThing.next;
    }
    return cnt;
  }

  private void printStats() {
    println(mSize + " ints: " + cntI + " & pairs: " + cntP + " mem: " + countThings() + " M&Ss: " + cntMS);
  }
}
