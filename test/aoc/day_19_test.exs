defmodule AoC.Day19Test do
  use ExUnit.Case

  import AoC.Day19Elephant

  test "winner_stealing_from_the_left" do
    assert winner_stealing_from_the_left(1) == 1
    assert winner_stealing_from_the_left(2) == 1
    assert winner_stealing_from_the_left(3) == 3
    assert winner_stealing_from_the_left(4) == 1
    assert winner_stealing_from_the_left(5) == 3
    assert winner_stealing_from_the_left(6) == 5
    assert winner_stealing_from_the_left(7) == 7
  end
end
