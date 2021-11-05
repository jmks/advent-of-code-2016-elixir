defmodule AoC.Day01NoTimeTest do
  use ExUnit.Case

  import AoC.Day01NoTime

  test "parse_directions" do
    assert parse_directions("R2, L3") == [{:right, 2}, {:left, 3}]
  end

  test "blocks_away" do
    assert blocks_away("R2, L3") == 5
    assert blocks_away("R2, R2, R2") == 2
    assert blocks_away("R5, L5, R5, R3") == 12
  end

  test "first_visited_twice" do
    assert first_visited_twice("R8, R4, R4, R8") == 4
  end
end
