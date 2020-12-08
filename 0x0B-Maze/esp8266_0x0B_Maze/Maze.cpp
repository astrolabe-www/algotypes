#ifndef _MAZE_CLASS_
#define _MAZE_CLASS_

#include <vector>
#include <math.h>
#include "Cell.cpp"

class Maze {
  public:
    int size;
    std::vector< std::vector<Cell> > mGrid;
    std::vector< std::vector<bool> > visited;

    Maze(int* input, int input_length) {
      size = ceil(sqrt(input_length));
      Stack mStack = Stack();

      for (int y = 0; y < size; y++) {
        std::vector<Cell> cellRow;
        std::vector<bool> boolRow;
        for (int x = 0; x < size; x++) {
          cellRow.push_back(Cell(x, y, input[(y * size + x) % input_length]));
          boolRow.push_back(false);
        }
        mGrid.push_back(cellRow);
        visited.push_back(boolRow);
      }

      Cell* current = &(mGrid[0][0]);
      visited[current->y][current->x] = true;
      mStack.push(current);

      while (!mStack.isEmpty()) {
        current = mStack.pop();
        Cell* neighbor = getValidNeighbor(current);
        if (neighbor != NULL) {
          mStack.push(current);

          current->wallH[neighbor->x - current->x + 1] = false;
          neighbor->wallH[current->x - neighbor->x + 1] = false;

          current->wallV[neighbor->y - current->y + 1] = false;
          neighbor->wallV[current->y - neighbor->y + 1] = false;

          visited[neighbor->y][neighbor->x] = true;
          mStack.push(neighbor);
        }
      }
    }

    std::vector<int> find(int v) {
      Queue mQueue = Queue();
      std::vector< std::vector<bool> > fVisited;
      std::vector<int> fValues;

      for (int y = 0; y < size; y++) {
        std::vector<bool> boolRow;
        for (int x = 0; x < size; x++) {
          boolRow.push_back(false);
        }
        fVisited.push_back(boolRow);
      }

      Cell* c0 = &(mGrid[(int)(random(size))][(int)(random(size))]);
      fVisited[c0->y][c0->x] = true;
      mQueue.push(c0);

      while (!mQueue.isEmpty()) {
        Cell* n = mQueue.pop();
        fValues.push_back(n->v);

        if (n->v == v) {
          mQueue.clear();
        } else {
          if (!n->wallH[0] && !fVisited[n->y][n->x - 1]) {
            fVisited[n->y][n->x - 1] = true;
            mQueue.push(&(mGrid[n->y][n->x - 1]));
          }
          if (!n->wallH[2] && !fVisited[n->y][n->x + 1]) {
            fVisited[n->y][n->x + 1] = true;
            mQueue.push(&(mGrid[n->y][n->x + 1]));
          }
          if (!n->wallV[0] && !fVisited[n->y - 1][n->x]) {
            fVisited[n->y - 1][n->x] = true;
            mQueue.push(&(mGrid[n->y - 1][n->x]));
          }
          if (!n->wallV[2] && !fVisited[n->y + 1][n->x]) {
            fVisited[n->y + 1][n->x] = true;
            mQueue.push(&(mGrid[n->y + 1][n->x]));
          }
        }
      }
      return fValues;
    }

  private:
    Cell* getValidNeighbor(Cell* c) {
      std::vector<Cell*> mNeighbors;

      if ((c->x - 1) > 0 && !visited[c->y][c->x - 1]) {
        mNeighbors.push_back(&(mGrid[c->y][c->x - 1]));
      }
      if ((c->x + 1) < size && !visited[c->y][c->x + 1]) {
        mNeighbors.push_back(&(mGrid[c->y][c->x + 1]));
      }
      if ((c->y - 1) > 0 && !visited[c->y - 1][c->x]) {
        mNeighbors.push_back(&(mGrid[c->y - 1][c->x]));
      }
      if ((c->y + 1) < size && !visited[c->y + 1][c->x]) {
        mNeighbors.push_back(&(mGrid[c->y + 1][c->x]));
      }

      return (mNeighbors.size() > 0) ? mNeighbors[(int)random(mNeighbors.size())] : NULL;
    }
};

#endif
