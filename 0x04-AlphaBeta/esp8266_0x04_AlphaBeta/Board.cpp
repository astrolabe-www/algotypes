#ifndef _BOARD_CLASS_
#define _BOARD_CLASS_

#include <vector>
#include <Arduino.h>

class Board {
  public:
    static const byte SQUARE_LENGTH = (byte)0x6;
    static const byte ROWS_OF_PIECES = (byte)0x1;
    static const byte COLS_PADDING = (byte)0x0;
    static const byte PLAYER_ALPHABETA = (byte)0x1;
    static const byte PLAYER_INPUT = (byte)0x2;

    byte square[SQUARE_LENGTH][SQUARE_LENGTH];

    Board() {
      resetBoard();
    }

    void resetBoard() {
      for (int i = 0; i < SQUARE_LENGTH; i++) {
        byte piece = (i < ROWS_OF_PIECES) ? PLAYER_ALPHABETA : (i > (SQUARE_LENGTH - ROWS_OF_PIECES - 1) ? PLAYER_INPUT : 0x0);

        for (int j = 0; j < SQUARE_LENGTH; j++) {
          square[i][j] = (j >= COLS_PADDING && j < (SQUARE_LENGTH - COLS_PADDING)) ? piece : 0x0;
        }
      }
    }

    void setFromBoard(Board* b) {
      for (int i = 0; i < SQUARE_LENGTH; i++) {
        for (int j = 0; j < SQUARE_LENGTH; j++) {
          square[i][j] = b->square[i][j];
        }
      }
    }

    bool isMove(byte player, int i, int j) {
      return (i >= 0) && (i < SQUARE_LENGTH) &&
             (j >= 0) && (j < SQUARE_LENGTH) &&
             (square[i][j] != player);
    }

    void makeMove(byte player, int fromFile, int fromRank, int toFile, int toRank) {
      square[fromRank][fromFile] = 0x0;
      square[toRank][toFile] = player;
    }

    int score(byte player) {
      int playerCount = 0;
      int otherCount = 0;
      byte other = (byte)(~player & 0x3);

      for (int i = 0; i < SQUARE_LENGTH; i++) {
        for (int j = 0; j < SQUARE_LENGTH; j++) {
          if (square[i][j] == player) playerCount++;
          else if (square[i][j] == other) otherCount++;
        }
      }
      return playerCount - otherCount;
    }

    void getMoves(byte player, std::vector<Board> &moves) {
      moves.clear();
      int moveCount = 0;

      for (int i = 0; i < SQUARE_LENGTH; i++) {
        for (int j = 0; j < SQUARE_LENGTH; j++) {
          if (square[i][j] == player) {
            for (int x = -2; x <= 2; x++) {
              for (int y = -2; y <= 2; y++) {
                if ((abs(x) != abs(y)) && (x != 0) && (y != 0)) {
                  if (isMove(player, i + y, j + x)) {
                    Board nBoard;
                    nBoard.setFromBoard(this);
                    moves.push_back(nBoard);
                    moves[moveCount].makeMove(player, j, i, j + x, i + y);
                    moveCount += 1;
                  }
                }
              }
            }
          }
        }
      }
    }

    static int minimax(Board &b, int depth, int alpha, int beta, boolean maximizingPlayer, byte scorePlayer) {
      std::vector<Board> moves;
      b.getMoves(maximizingPlayer ? PLAYER_ALPHABETA : PLAYER_INPUT, moves);

      if (depth == 0 || moves.size() == 0) {
        return b.score(scorePlayer);
      }

      int value = (maximizingPlayer) ? -1000 : 1000;
      if (maximizingPlayer) {
        for (int m = 0; m < moves.size(); m++) {
          value = max(value, minimax(moves[m], depth - 1, alpha, beta, !maximizingPlayer, scorePlayer));
          alpha = max(alpha, value);
          if (alpha >= beta) break;
        }
      } else {
        for (int m = 0; m < moves.size(); m++) {
          value = min(value, minimax(moves[m], depth - 1, alpha, beta, !maximizingPlayer, scorePlayer));
          beta = min(beta, value);
          if (alpha >= beta) break;
        }
      }
      return value;
    }
};

#endif
