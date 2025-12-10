defmodule AoC.Day24Test do
  use ExUnit.Case

  import AoC.Day24Spurlunking
  alias AoC.Day24Spurlunking.Maze

  @maze """
  ###########
  #0.1.....2#
  #.#######.#
  #4.......3#
  ###########
  """

  test "parsing" do
    maze = Maze.parse(@maze)

    refute Maze.open?(maze, {0, 0})
    assert Maze.open?(maze, {1, 1})
    assert Maze.open?(maze, {3, 3})
  end

  test "adjacent_coordinates" do
    maze = Maze.parse(@maze)

    assert Maze.adjacent_coordinates(maze, {1, 1}) == [{2, 1}, {1, 2}]
  end

  test "movement" do
    maze = Maze.parse(@maze)

    assert Maze.shortest_distance(maze, 0, 4) == 2
    assert Maze.shortest_distance(maze, 4, 1) == 4
    assert Maze.shortest_distance(maze, 1, 2) == 6
    assert Maze.shortest_distance(maze, 2, 3) == 2
  end

  test "paths" do
    assert permutations([1,2,3]) == [
      [1, 2, 3],
      [1, 3, 2],
      [2, 1, 3],
      [2, 3, 1],
      [3, 1, 2],
      [3, 2, 1]
    ]
  end

  test "fewest_steps" do
    assert fewest_steps(@maze) == 14
  end
end
