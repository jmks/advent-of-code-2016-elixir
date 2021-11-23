defmodule AoC.Day19Test do
  use ExUnit.Case

  import AoC.Day19Elephant
  alias AoC.Day19Elephant.Zipper

  describe "Zipper" do
    import Zipper

    test "cycle through elements" do
      z = new([1,2,3])
      assert current(z) == 1

      z = forward(z)
      assert current(z) == 2

      z = forward(z)
      assert current(z) == 3

      z = forward(z)
      assert current(z) == 1
    end

    test "removes elements" do
      z = new([1,2,3]) |> forward() |> delete()

      assert current(z) == 3

      z = forward(z)
      assert current(z) == 1
    end

    test "removes the last element" do
      z = new([1,2,3]) |> forward() |> forward() |> delete()

      assert current(z)
    end
  end

  test "winner :steal_left" do
    assert winner(1, :steal_left) == 1
    assert winner(2, :steal_left) == 1
    assert winner(3, :steal_left) == 3
    assert winner(4, :steal_left) == 1
    assert winner(5, :steal_left) == 3
    assert winner(6, :steal_left) == 5
    assert winner(7, :steal_left) == 7
  end
end
