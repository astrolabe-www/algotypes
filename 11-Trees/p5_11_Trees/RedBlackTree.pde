public class RedBlackTree extends Tree {
  private RedBlackNode root;

  public RedBlackTree() {
    super();
  }

  public Node insert(Node n) {
    RedBlackNode newNode = new RedBlackNode(n);

    if (root == null) {
      root = newNode;
      super.root = root;
      return newNode;
    } else return insert(newNode, root);
  }

  private Node insert(RedBlackNode n, RedBlackNode root) {
    return n;
    // TODO
  }
}

public class RedBlackNode extends Node {
  private boolean isBlack;

  public RedBlackNode(int v) {
    super(v);
    isBlack = true;
  }

  public RedBlackNode(Node n) {
    super(n);
    isBlack = true;
  }
}
