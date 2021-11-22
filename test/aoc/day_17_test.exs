defmodule AoC.Day17Test do
  use ExUnit.Case

  import AoC.Day17TwoSteps

  test "door_states" do
    assert door_states("hijkl", []) == [up: :open, down: :open, left: :open, right: :closed]
  end

  test "shortest_path" do
    assert shortest_path("ihgpwlah") == "DDRRRD"
    assert shortest_path("kglvqrro") == "DDUDRLRRUDRD"
    assert shortest_path("ulqzkmiv") == "DRURDRUDDLLDLUURRDULRLDUUDDDRR"
  end

  test "longest_path" do
    assert longest_path("ihgpwlah") == 370
    assert longest_path("kglvqrro") == 492
    assert longest_path("ulqzkmiv") == 830
  end
end
