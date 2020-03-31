public class Maze {
  public int size;
  public Cell[][] mGrid;
  public boolean[][] visited;

  public Maze(int[] input) {
    randomSeed(10);

    size = ceil(sqrt(input.length));
    mGrid = new Cell[size][size];
    visited = new boolean[size][size];
    Stack mStack = new Stack();

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        mGrid[y][x] = new Cell(x, y, input[(y * size + x) % input.length]);
        visited[y][x] = false;
      }
    }

    Cell current = mGrid[0][0];
    visited[current.y][current.x] = true;
    mStack.push(current);

    while (!mStack.isEmpty()) {
      current = mStack.pop();
      Cell neighbor = getValidNeighbor(current);
      if (neighbor != null) {
        mStack.push(current);

        current.wallH[neighbor.x - current.x + 1] = false;
        neighbor.wallH[current.x - neighbor.x + 1] = false;

        current.wallV[neighbor.y - current.y + 1] = false;
        neighbor.wallV[current.y - neighbor.y + 1] = false;

        visited[neighbor.y][neighbor.x] = true;
        mStack.push(neighbor);
      }
    }
  }

  private Cell getValidNeighbor(Cell c) {
    Cell[] mNeighbors = new Cell[4];
    int neightborCounter = 0;

    if ((c.x - 1) > 0 && !visited[c.y][c.x - 1]) {
      mNeighbors[neightborCounter] = mGrid[c.y][c.x - 1];
      neightborCounter++;
    }
    if ((c.x + 1) < mGrid[c.y].length && !visited[c.y][c.x + 1]) {
      mNeighbors[neightborCounter] = mGrid[c.y][c.x + 1];
      neightborCounter++;
    }
    if ((c.y - 1) > 0 && !visited[c.y - 1][c.x]) {
      mNeighbors[neightborCounter] = mGrid[c.y - 1][c.x];
      neightborCounter++;
    }
    if ((c.y + 1) < mGrid.length && !visited[c.y + 1][c.x]) {
      mNeighbors[neightborCounter] = mGrid[c.y + 1][c.x];
      neightborCounter++;
    }

    return (neightborCounter == 0) ? null : mNeighbors[(int)random(0, neightborCounter)];
  }
}

public class Cell {  
  public int v;
  public int x;
  public int y;
  public boolean[] wallH = {true, true, true};
  public boolean[] wallV = {true, true, true};


  public Cell(int x, int y, int v) {
    this.x = x;
    this.y = y;
    this.v = v;
  }
}

private class linkedCell {
  private Cell c;
  private linkedCell next;

  public linkedCell(Cell c) {
    this.c = c;
    next = null;
  }
}

public class Stack {
  private linkedCell head;
  private int size;

  public Stack() {
    size = 0;
    head = null;
  }

  public void push(Cell c) {
    linkedCell sC = new linkedCell(c);
    sC.next = head;
    head = sC;
    size += 1;
  }

  public Cell pop() {
    Cell r = head.c;
    head = head.next;
    size -= 1;
    return r;
  }

  public boolean isEmpty() {
    return (size == 0);
  }
}

public class Queue {
  private linkedCell head;
  private linkedCell tail;
  private int size;

  public Queue() {
    size = 0;
    head = null;
    tail = null;
  }

  public void push(Cell c) {
    linkedCell qC = new linkedCell(c);

    if (size == 0) head = qC;
    else tail.next = qC;

    tail = qC;
    size += 1;
  }

  public Cell pop() {
    Cell r = head.c;
    head = head.next;
    size -= 1;

    if (size == 0) tail = null;

    return r;
  }

  public boolean isEmpty() {
    return (size == 0);
  }

  public void clear() {
    size = 0;
    head = null;
    tail = null;
  }
}
