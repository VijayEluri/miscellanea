package com.rdsr.gameoflife;

import junit.framework.Assert;

import org.junit.Test;

import com.rdsr.gameoflife.cell.Cell;
import com.rdsr.gameoflife.cell.TwoDPosition;
import com.rdsr.gameoflife.transition.TransitionRule;
import com.rdsr.gameoflife.transition.TwoDTransitionRule;
import com.rdsr.gameoflife.world.TwoDWorld.TwoDWorldBuilder;
import com.rdsr.gameoflife.world.World;
import com.rdsr.gameoflife.world.WorldBuilder;

public class GameOfLifeTest {
  private final TransitionRule twoDTransitionRule = TwoDTransitionRule.INSTANCE;
  private final WorldBuilder twoDWorldBuilder = new TwoDWorldBuilder();

  @Test
  public void testcase1() {
    // Block pattern - Still life
    final World seededWorld = buildWorld(
        1, 1,
        1, 2,
        2, 1,
        2, 2);

    final World expectedWorld = buildWorld(
        1, 1,
        1, 2,
        2, 1,
        2, 2);

    runTest(seededWorld, expectedWorld);
  }

  @Test
  public void testcase2() {
    // Boat pattern - Still life
    final World seededWorld = buildWorld(
        0, 1,
        1, 0,
        2, 1,
        0, 2,
        1, 2);

    final World expectedWorld = buildWorld(
        0, 1,
        1, 0,
        2, 1,
        0, 2,
        1, 2);

    runTest(seededWorld, expectedWorld);
  }

  @Test
  public void testcase3() {
    // Blinker pattern - oscillator
    final World seededWorld = buildWorld(
        1, 1,
        1, 0,
        1, 2);

    final World expectedWorld = buildWorld(
        1, 1,
        0, 1,
        2, 1);

    runTest(seededWorld, expectedWorld);
  }

  @Test
  public void testcase4() {
    // Toad pattern - two phase oscillator
    final World seededWorld = buildWorld(
        1, 1,
        1, 2,
        1, 3,
        2, 2,
        2, 3,
        2, 4);

    final World expectedWorld = buildWorld(
        0, 2,
        1, 1,
        1, 4,
        2, 1,
        2, 4,
        3, 3);

    runTest(seededWorld, expectedWorld);
  }

  @Test
  public void testcase5() {
    // no living cell.
    final World seededWorld = buildWorld();
    final World expectedWorld = buildWorld();
    runTest(seededWorld, expectedWorld);
  }
  
  @Test
  public void testcase6() {
    // one living cell
    final World seededWorld = buildWorld(10, 10);
    final World expectedWorld = buildWorld();
    runTest(seededWorld, expectedWorld);
  }
  
  @Test
  public void testcase7() {
    // cells are not neighbors
    final World seededWorld = buildWorld(0, 0, 10, 10, 20, 20);
    final World expectedWorld = buildWorld();
    runTest(seededWorld, expectedWorld);
  }
  
  @Test
  public void testcase8() {
    // insufficient neighbors
    final World seededWorld = buildWorld(0, 0, 1, 0);
    final World expectedWorld = buildWorld();
    runTest(seededWorld, expectedWorld);
  }
  
  private void runTest(World seededWorld, World expectedWorld) {
    final GameOfLife gameOfLife = new GameOfLife(seededWorld, twoDWorldBuilder, twoDTransitionRule, 1);
    final World computedWorld = gameOfLife.generate();
    Assert.assertEquals(expectedWorld, computedWorld);
  }

  private World buildWorld(int... integers) {
    twoDWorldBuilder.init();

    for (int i = 0; i < integers.length; i += 2)
      twoDWorldBuilder.update(new TwoDPosition(integers[i], integers[i + 1]), Cell.LIVING);

    return twoDWorldBuilder.build();
  }
}
