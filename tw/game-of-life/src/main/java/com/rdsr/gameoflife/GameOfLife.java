package com.rdsr.gameoflife;

import java.util.Map;

import com.rdsr.gameoflife.cell.Cell;
import com.rdsr.gameoflife.cell.Position;
import com.rdsr.gameoflife.transition.TransitionRule;
import com.rdsr.gameoflife.world.World;
import com.rdsr.gameoflife.world.WorldBuilder;

/**
 * The class that ties everything together.
 */
public class GameOfLife {
  final private World seededWorld;
  final private WorldBuilder worldBuilder;
  final private TransitionRule rule;
  final private int noOfgenerations;

  public GameOfLife(World _world, WorldBuilder _worldBuilder, TransitionRule _rule, int _noOfGenerations) {
    seededWorld = _world;
    worldBuilder = _worldBuilder;
    rule = _rule;
    noOfgenerations = _noOfGenerations;

  }

  private World tick(World world) {
    /**
     * a tick is one run of application when all the rules are applied
     * simultaneously on all the cells.
     */
    worldBuilder.init();
    final Map<Position, Cell> allCells = world.listAllCells();

    for (final Position position : allCells.keySet()) {
      final Cell updatedCell = rule.update(allCells.get(position), position, world.getNeighbors(position));
      worldBuilder.update(position, updatedCell);
    }

    return worldBuilder.build();
  }

  public World generate() {
    World nextGenerationWorld = seededWorld;
    for (int i = 0; i < noOfgenerations; i++)
      nextGenerationWorld = tick(nextGenerationWorld);
    return nextGenerationWorld;
  }
}