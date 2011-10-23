package com.rdsr.gameoflife.world;

import java.util.List;
import java.util.Map;

import com.rdsr.gameoflife.cell.Cell;
import com.rdsr.gameoflife.cell.Position;

public interface World {
  /**
   * Lists all the cells a world contains.
   */
  Map<Position, Cell> listAllCells();

  /**
   * Lists all the neighbors pertaining to a position.
   */
  List<Cell> getNeighbors(Position position);
}
