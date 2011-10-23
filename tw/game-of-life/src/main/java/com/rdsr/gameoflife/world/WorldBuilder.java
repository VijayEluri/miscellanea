package com.rdsr.gameoflife.world;

import com.rdsr.gameoflife.cell.Cell;
import com.rdsr.gameoflife.cell.Position;

/**
 * A WorldBuilder knows how to build a world.
 */
public interface WorldBuilder {
 /**
  * we call init before we start building.
  */
  void init();

  WorldBuilder update(Position position, Cell cell);

  /**
   * when we are done building, we return the World
   */
  World build();
}
