package com.rdsr.gameoflife.world;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.rdsr.gameoflife.cell.Cell;
import com.rdsr.gameoflife.cell.Position;

public class TwoDWorld implements World {

  /**
   * Assumptions: Currently in a 2d world, just the live cells are stored.
   * If a cell is no present in the liveCellMap, its either dead or non-existent.
   * (This is as per the current problem statement).
   * Storing just the live cells is more efficient too. Since this world
   * is infinite, we can't possibly store every cell.
   */
  final Map<Position, Cell> liveCellMap;

  private TwoDWorld(Map<Position, Cell> map) {
    this.liveCellMap = map;
  }

  @Override
  public Map<Position, Cell> listAllCells() {
    final Map<Position, Cell> allCells = new HashMap<Position, Cell>();

    for (final Position position : liveCellMap.keySet()) {
      allCells.put(position, liveCellMap.get(position));
      /**
       * We also return all the dead neighbors of a live cell,
       * since there could be a chance that one of these dead
       * cells can change state.
       */
      for (final Position neighborPosition : position.listAllNeighorPositions())
        if (!allCells.containsKey(neighborPosition))
          allCells.put(neighborPosition, Cell.DEAD);
    }

    return allCells;
  }

  /**
   * returns all the neighbors of a given position. The neighbors include
   * both dead and live cells
   */
  @Override
  public List<Cell> getNeighbors(Position position) {
    if (position == null)
      throw new IllegalArgumentException("Position is null");

    final List<Cell> neighbors = new ArrayList<Cell>();
    for (final Position neighborPosition : position.listAllNeighorPositions()) {
      if (liveCellMap.containsKey(neighborPosition))
        neighbors.add(liveCellMap.get(neighborPosition));
      else
        neighbors.add(Cell.DEAD);
    }

    return neighbors;
  }

  @Override
  public String toString() {
    final StringBuilder s = new StringBuilder();
    final List<Position> positions = new ArrayList<Position>(liveCellMap.keySet());
    Collections.sort(positions);

    for (final Position position : positions) {
      s.append(position).append("\n");
    }
    return s.toString();
  }

  /**
   * auto generated by eclipse
   */
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((liveCellMap == null) ? 0 : liveCellMap.hashCode());
    return result;
  }

  /**
   * auto generated by eclipse
   */
  @Override
  public boolean equals(Object obj) {
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    if (getClass() != obj.getClass())
      return false;
    final TwoDWorld other = (TwoDWorld) obj;
    if (liveCellMap == null) {
      if (other.liveCellMap != null)
        return false;
    } else if (!liveCellMap.equals(other.liveCellMap))
      return false;
    return true;
  }

  public static class TwoDWorldBuilder implements WorldBuilder {

    Map<Position, Cell> partialWorld = new HashMap<Position, Cell>();

    @Override
    public void init() {
      partialWorld = new HashMap<Position, Cell>();
    }

    @Override
    public WorldBuilder update(Position position, Cell cell) {
      if (cell.getState() == Cell.State.LIVING)
        // 2d world only maintains mappings for living cells
        partialWorld.put(position, cell); // 2D world only works with 2d position
      return this;
    }

    @Override
    public World build() {
      return new TwoDWorld(partialWorld);
    }
  }
}