package com.rdsr.gameoflife.transition;

import java.util.List;

import com.rdsr.gameoflife.cell.Cell;
import com.rdsr.gameoflife.cell.Position;

public interface TransitionRule {
  /**
   * A Transition rule updates the state of a cell based
   * on the cell's current position and its neighbors.
   */
  Cell update(Cell cell, Position position, List<Cell> neighbors);
}
