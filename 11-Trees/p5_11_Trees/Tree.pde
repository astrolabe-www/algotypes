public class Tree {
  protected Node root;

  public Tree() {
    root = null;
  }

  public Node getRoot(){
    return root;
  }

  public Node find(int v) {
    if (root == null) return null;
    else return find(v, root);
  }

  private Node find(int v, Node n) {
    if (n == null) return null;
    else if (v == n.value) return n;
    else if (v < n.value) return find(v, n.left);
    else return find(v, n.right);
  }

  public String toString() {
    String s = "";
    // TODO
    return s;
  }

  public void insert(Node n) {
    if (root == null) root = n;
    else insert(n, root);
  }

  private void insert(Node n, Node root) {
    if (n.value == root.value) {
      root.count += n.count;
    } else if (n.value < root.value) {
      if (root.left == null) {
        root.left = n;
        n.parent = root;
      } else {
        insert(n, root.left);
      }
    } else {
      if (root.right == null) {
        root.right = n;
        n.parent = root;
      } else {
        insert(n, root.right);
      }
    }
  }
}

class Node {
  private int value;
  private int count;
  private Node left;
  private Node right;
  private Node parent;

  public Node(int v) {
    value = v;
    count = 1;
    left = right = parent = null;
  }

  public Node(Node n) {
    value = n.value;
    count = n.count;
    left = n.left;
    right = n.right;
    parent = n.parent;
  }
}
