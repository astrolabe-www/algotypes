public class RedBlackTree extends Tree {
  private RedBlackNode root;

  public RedBlackTree() {
    super();
  }

  public void insert(Node n) {
    if (root == null) root = new RedBlackNode(n);
    else insert(new RedBlackNode(n), root);
    super.root = root;
  }

  private void insert(RedBlackNode n, RedBlackNode root) {
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
