#ifndef _CELL_CLASS_
#define _CELL_CLASS_

#include <Arduino.h>

class Cell {
  public:
    int v;
    int x;
    int y;
    bool wallH[3] = { true, true, true };
    bool wallV[3] = { true, true, true };

    Cell(int _x, int _y, int _v) {
      x = _x;
      y = _y;
      v = _v;
    }
};

class LinkedCell {
  public:
    Cell* c;
    LinkedCell* next;
    LinkedCell(Cell* _c) {
      c = _c;
      next = NULL;
    }
};

class Stack {
  private:
    LinkedCell* head;
    int size;

  public:
    Stack() {
      size = 0;
      head = NULL;
    }

    void push(Cell* c) {
      LinkedCell* sC = new LinkedCell(c);
      sC->next = head;
      head = sC;
      size += 1;
    }

    Cell* pop() {
      LinkedCell* oldHead = head;
      Cell* r = oldHead->c;
      head = oldHead->next;
      delete oldHead;
      size -= 1;
      return r;
    }

    bool isEmpty() {
      return (size == 0);
    }
};

class Queue {
  private:
    LinkedCell* head;
    LinkedCell* tail;
    int size;

  public:
    Queue() {
      size = 0;
      head = NULL;
      tail = NULL;
    }

    void push(Cell* c) {
      LinkedCell* qC = new LinkedCell(c);

      if (size == 0) head = qC;
      else tail->next = qC;

      tail = qC;
      size += 1;
    }

    Cell* pop() {
      LinkedCell* oldHead = head;
      Cell* r = oldHead->c;
      head = oldHead->next;
      delete oldHead;
      size -= 1;

      if (size == 0) tail = NULL;

      return r;
    }

    bool isEmpty() {
      return (size == 0);
    }

    void clear() {
      while(!isEmpty())
        pop();
      size = 0;
      head = NULL;
      tail = NULL;
    }
};

#endif
