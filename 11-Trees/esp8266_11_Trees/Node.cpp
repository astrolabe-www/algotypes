#ifndef _NODE_CLASS_
#define _NODE_CLASS_

#include <vector>
#include <Arduino.h>

class Node {
  public:
    int value;
    int count;
    Node* left;
    Node* right;
    Node* parent;

    Node(int v) {
      value = v;
      count = 1;
      left = right = parent = NULL;
    }

    ~Node() {
      delete left;
      delete right;
    }

    bool isLeftChild() {
      if (parent == NULL) return false;
      else return (parent->left == this);
    }

    void depthFirst(std::vector<int> &dftOrder) {
      if (left != NULL) left->depthFirst(dftOrder);
      if (right != NULL) right->depthFirst(dftOrder);
      for (int i = 0; i < count; i++) dftOrder.push_back(value);
    }
};

#endif
