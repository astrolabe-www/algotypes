#ifndef _SPLAY_CLASS_
#define _SPLAY_CLASS_

#include <vector>
#include <Arduino.h>
#include "Node.cpp"

class SplayTree {
  public:
    SplayTree(int* input, int input_length) {
      root = NULL;
      for (int i = 0; i < input_length; i++) {
        Node* n = new Node(input[i]);
        this->insert(n);
      }
    }

    ~SplayTree() {
      if (root != NULL) {
        delete root;
      }
    }

    Node* insert(Node* n) {
      if (root == NULL) {
        root = n;
        return splay(root);
      } else return splay(insert(n, root));
    }

    void depthFirst(std::vector<int> &dftOrder) {
      if (root != NULL) root->depthFirst(dftOrder);
    }

  private:
    Node* root;

    Node* insert(Node* n, Node* root) {
      if (n->value == root->value) {
        root->count += n->count;
        delete n;
        return root;
      } else if (n->value < root->value) {
        if (root->left == NULL) {
          root->left = n;
          n->parent = root;
          return n;
        } else {
          return insert(n, root->left);
        }
      } else {
        if (root->right == NULL) {
          root->right = n;
          n->parent = root;
          return n;
        } else {
          return insert(n, root->right);
        }
      }
    }

    Node* splay(Node* n) {
      while (n->parent != NULL) {
        Node* p = n->parent;
        Node* gp = n->parent->parent;

        if (gp == NULL) {
          if (n->isLeftChild()) {
            zigRight(n);
          } else {
            zigLeft(n);
          }
        } else {
          if (gp->parent != NULL) {
            if (gp->isLeftChild()) gp->parent->left = n;
            else gp->parent->right = n;
          }

          if (p->isLeftChild() && n->isLeftChild()) {
            zigRight(p);
            zigRight(n);
          } else if (p->isLeftChild() == n->isLeftChild()) {
            zigLeft(p);
            zigLeft(n);
          } else if (p->isLeftChild()) {
            zigLeft(n);
            zigRight(n);
          } else {
            zigRight(n);
            zigLeft(n);
          }
        }
      }
      root = n;
      return root;
    }

    void zigRight(Node* n) {
      Node* p = n->parent;
      if (n->right != NULL) n->right->parent = p;
      n->parent = p->parent;
      p->parent = n;
      p->left = n->right;
      n->right = p;
    }

    void zigLeft(Node* n) {
      Node* p = n->parent;
      if (n->left != NULL) n->left->parent = p;
      n->parent = p->parent;
      p->parent = n;
      p->right = n->left;
      n->left = p;
    }
};

#endif
