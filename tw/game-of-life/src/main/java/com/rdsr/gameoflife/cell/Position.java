package com.rdsr.gameoflife.cell;

import java.util.List;

/**
 * A Position uniquely identifies a cell in a World.
 */
public interface Position extends Comparable<Position> {
  List<Position> listAllNeighorPositions();
}
