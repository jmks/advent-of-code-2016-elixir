defmodule AoC.Day03SquareWithThreeSidesTest do
  use ExUnit.Case

  import AoC.Day03SquareWithThreeSides

  test "possible_triagnle?" do
    refute possible_triangle?([10, 5, 25])
  end
end
