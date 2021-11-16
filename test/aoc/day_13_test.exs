defmodule AoC.Day13Test do
  use ExUnit.Case

  import AoC.Day13Maze
  alias AoC.Day13Maze.Maze

  test "shortest_path" do
    assert shortest_path(Maze.new(10), {1, 1}, {7, 4}) == 11
  end
end
