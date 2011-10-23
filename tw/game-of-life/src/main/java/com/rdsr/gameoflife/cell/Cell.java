package com.rdsr.gameoflife.cell;

/**
 * A very basic immutable class having just two states (LIVING and DEAD)
 */
public class Cell {

  public enum State {
    LIVING, DEAD
  };

  public static final Cell LIVING = new Cell(State.LIVING);
  public static final Cell DEAD = new Cell(State.DEAD);

  private final State state;

  private Cell(State state) {
    this.state = state;
  }

  public State getState() {
    return state;
  }

  @Override
  public String toString() {
    return "Cell:" + state;
  }
}
