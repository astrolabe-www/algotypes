public class Board {
  private byte[][] square;

  public Board() {
    square = new byte[8][8];

    for (int i = 0; i < square.length; i++) {
      byte piece = (byte)((i < 2) ? 0x1 : (i > square.length - 3 ? 0x2 : 0x0));
      for (int j = 0; j < square[i].length; j++) {
        square[i][j] = piece;
      }
    }
  }

  public Board(Board b) {
    square = new byte[8][8];

    for (int i = 0; i < square.length; i++) {
      for (int j = 0; j < square[i].length; j++) {
        square[i][j] = b.square[i][j];
      }
    }
  }

  public boolean isMove(byte player, int i, int j) {
    return (i >= 0) && (i < square.length) &&
      (j >= 0) && (j < square[0].length) &&
      (square[i][j] != player);
  }

  public int score(byte player) {
    int playerCount = 0;
    int otherCount = 0;
    byte other = (byte)(~player & 0x3);

    for (int i = 0; i < square.length; i++) {
      for (int j = 0; j < square[i].length; j++) {
        if (square[i][j] == player) playerCount++;
        else if (square[i][j] == other) otherCount++;
      }
    }
    return playerCount - otherCount;
  }

  public Board[] moves(byte player) {
    Board[] temp = new Board[8 * 16];
    int moveCount = 0;

    for (int i = 0; i < square.length; i++) {
      for (int j = 0; j < square[i].length; j++) {
        if (square[i][j] == player) {
          for (int x = -2; x <= 2; x++) {
            for (int y = -2; y <= 2; y++) {
              if ((abs(x) != abs(y)) && (x != 0) && (y !=0)) {
                if (isMove(player, i + y, j + x)) {
                  temp[moveCount] = new Board(this);
                  temp[moveCount].square[i][j] = 0x0;
                  temp[moveCount].square[i + y][j + x] = player;
                  moveCount += 1;
                }
              }
            }
          }
        }
      }
    }

    Board[] r = new Board[moveCount];
    for (int i = 0; i < r.length; i++) {
      r[i] = temp[i];
    }
    return r;
  }
}

public static class AlphaBeta {

  public static int minimax(Board b, int depth, int alpha, int beta, boolean maximizingPlayer, byte scorePlayer) {
    Board[] moves = b.moves((byte)(maximizingPlayer ? 0x1 : 0x2));

    if (depth == 0 || moves.length == 0) {
      return b.score(scorePlayer);
    }

    int value = (maximizingPlayer) ? -1000 : 1000;
    if (maximizingPlayer) {
      for (int m = 0; m < moves.length; m++) {
        value = max(value, minimax(moves[m], depth - 1, alpha, beta, !maximizingPlayer, scorePlayer));
        alpha = max(alpha, value);
        if (alpha >= beta) break;
      }
    } else {
      for (int m = 0; m < moves.length; m++) {
        value = min(value, minimax(moves[m], depth - 1, alpha, beta, !maximizingPlayer, scorePlayer));
        beta = min(beta, value);
        if (alpha >= beta) break;
      }
    }
    return value;
  }
}
