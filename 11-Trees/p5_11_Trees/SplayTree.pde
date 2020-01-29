public class SplayTree extends Tree {

  public SplayTree() {
    super();
  }

  public Node insert(Node n) {
    return splay(super.insert(n));
  }

  private Node splay(Node n) {
    while (n.parent != null) {
      Node p = n.parent;
      Node gp = n.parent.parent;

      if (gp == null) {
        if (n.isLeftChild()) {
          zigRight(n);
        } else {
          zigLeft(n);
        }
      } else {
        if(gp.parent != null) {
          if(gp.isLeftChild()) gp.parent.left = n;
          else gp.parent.right = n;
        }

        if (p.isLeftChild() && n.isLeftChild()) {
          zigRight(p);
          zigRight(n);
        } else if (p.isLeftChild() == n.isLeftChild()) {
          zigLeft(p);
          zigLeft(n);
        } else if (p.isLeftChild()) {
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

  private void zigRight(Node n) {
    Node p = n.parent;
    if (n.right != null) n.right.parent = p;
    n.parent = p.parent;
    p.parent = n;
    p.left = n.right;
    n.right = p;
  }

  private void zigLeft(Node n) {
    Node p = n.parent;
    if (n.left != null) n.left.parent = p;
    n.parent = p.parent;
    p.parent = n;
    p.right = n.left;
    n.left = p;
  }
}
