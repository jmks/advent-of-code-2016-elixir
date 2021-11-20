defmodule AoC.Day15Test do
  use ExUnit.Case

  import AoC.Day15Timing

  @example """
  Disc #1 has 5 positions; at time=0, it is at position 4.
  Disc #2 has 2 positions; at time=0, it is at position 1.
  """

  test "parse" do
    assert parse(@example) == [
      [1, 5, 0, 4],
      [2, 2, 0, 1]
    ]
  end

  test "earliest_fall_through" do
    assert earliest_fall_through(@example) == 5
  end
end
