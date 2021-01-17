enum ThingType {
  INT, 
  PAIR
}

class Thing {
  ThingType type;
  boolean marked;

  int value;
  Thing one;
  Thing two;

  Thing next;

  public Thing(ThingType tt) {
    type = tt;
    next = null;
  }

  protected void mark() {
    if(marked) return;
    marked = true;

    if(type == ThingType.PAIR) {
      if(one != null) one.mark();
      if(two != null)  two.mark();
    }
  }
}
