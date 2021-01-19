enum ThingType {
  INT,
  PAIR
}

class Thing {
  protected ThingType type;
  protected boolean marked;

  protected int value;
  protected Thing one;
  protected Thing two;

  public Thing(ThingType tt) {
    type = tt;
  }

  protected void mark() {
    if (marked) return;
    marked = true;

    if (type == ThingType.PAIR) {
      if (one != null) one.mark();
      if (two != null)  two.mark();
    }
  }
}
