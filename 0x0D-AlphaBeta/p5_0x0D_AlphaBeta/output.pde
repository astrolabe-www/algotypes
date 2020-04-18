void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.noFill();
  mpg.stroke(200, 0, 0, 128);
  mpg.strokeWeight(OUT_SCALE * 2.0);

  Board[] inputMoves;

  for (int i = 0; i < INPUT.length; i++) {
    // INPUT player
    inputMoves = mBoard.moves(PLAYER_INPUT);
    if (inputMoves.length == 0) {
      println("ALPHABETA WINS");
      break;
    }
    mBoard = inputMoves[INPUT[i] % inputMoves.length];
    mBoard.drawLastMove(mpg, OUT_SCALE * BORDER_WIDTH);

    // ALPHABETA player
    inputMoves = mBoard.moves(PLAYER_ALPHABETA);
    if (inputMoves.length == 0) {
      println("INPUT WINS");
      break;
    } else {
      int maxV = -1000;
      int maxM = 0;
      for (int m = 0; m < inputMoves.length; m++) {
        int v = AlphaBeta.minimax(inputMoves[m], 1, -1000, 1000, true, PLAYER_ALPHABETA);
        if (v > maxV) {
          maxV = v;
          maxM = m;
        }
      }
      mBoard = inputMoves[maxM];
      mBoard.drawLastMove(mpg, OUT_SCALE * BORDER_WIDTH);
    }
  }

  mpg.endDraw();
}
