defmodule AoC.Day08Test do
  use ExUnit.Case

  import AoC.Day08TwoFactor
  alias AoC.Day08TwoFactor.Screen

  describe "pixels_on" do
    test "rect" do
      assert pixels_on("rect 3x2") == 6
    end

    test "rotate" do
      assert pixels_on("""
      rect 3x2
      rotate row y=0 by 4
      """) == 6
      assert pixels_on("""
      rect 3x2
      rotate row y=0 by 4
      rotate column x=1 by 1
      """) == 6
    end
  end

  test "parse_instructions" do
    assert parse_instructions("""
    rect 3x2
    rotate row y=0 by 4
    rotate column x=1 by 1
    """) == [
      {:rect, 3, 2},
      {:rotate_row, 0, 4},
      {:rotate_col, 1, 1}
    ]
  end

  describe "Screen" do
    test "turn_on" do
      screen = Screen.new |> Screen.turn_on({1, 1})

      assert Screen.on?(screen, {1, 1})
    end

    test "rect" do
      screen = Screen.new |> Screen.instruction({:rect, 3, 2})

      assert Screen.on?(screen, {1, 1})
      assert Screen.on?(screen, {1, 2})
      assert Screen.on?(screen, {2, 1})
      assert Screen.on?(screen, {2, 2})
      assert Screen.on?(screen, {3, 1})
      assert Screen.on?(screen, {3, 2})
    end

    test "rotation" do
      screen = Screen.new(6, 4) |> Screen.instruction({:rect, 3, 2}) |> Screen.instruction({:rotate_col, 1, 1})

      [{1, 1}, {3, 1}, {1, 2}, {2, 2}, {3, 2}, {2, 3}]
      |> Enum.each(fn coordinate ->
        assert Screen.on?(screen, coordinate)
      end)
      refute Screen.on?(screen, {2, 1})
    end
  end
end
