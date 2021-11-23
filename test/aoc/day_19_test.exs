defmodule AoC.Day19Test do
  use ExUnit.Case

  import AoC.Day19Elephant

  test "winner" do
    assert winner(1) == 1
    assert winner(2) == 1
    assert winner(3) == 3
    assert winner(4) == 1
    assert winner(5) == 3
    assert winner(6) == 5
    assert winner(7) == 7
  end
end
