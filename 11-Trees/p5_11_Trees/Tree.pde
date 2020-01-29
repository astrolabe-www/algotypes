public class Tree {
  protected Node root;

  public Tree() {
    root = null;
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
    if (root == null) return "Ø";
    else return root.printNode();
  }

  public Node insert(Node n) {
    if (root == null) {
      root = n;
      return root;
    } else return insert(n, root);
  }

  private Node insert(Node n, Node root) {
    if (n.value == root.value) {
      root.count += n.count;
      return root;
    } else if (n.value < root.value) {
      if (root.left == null) {
        root.left = n;
        n.parent = root;
        return n;
      } else {
        return insert(n, root.left);
      }
    } else {
      if (root.right == null) {
        root.right = n;
        n.parent = root;
        return n;
      } else {
        return insert(n, root.right);
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

  public boolean isLeftChild() {
    if (parent == null) return false;
    else return (parent.left == this);
  }

  public String printNode() {
    StringBuilder buffer = new StringBuilder(1024);
    printNode(buffer, "", true);
    return buffer.toString();
  }

  private void printNode(StringBuilder buffer, String prefix, boolean fromLeft) {
    if (right != null) right.printNode(buffer, prefix + (fromLeft ? "│   " : "    "), false);

    buffer.append(prefix).append(fromLeft ? "└── " : "┌── ").append(value).append('\n');

    if (left != null) left.printNode(buffer, prefix + (fromLeft ? "    " : "│   "), true);
  }
}
