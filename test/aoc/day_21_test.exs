defmodule AoC.Day20Test do
  use ExUnit.Case

  import AoC.Day21Scramble

  test "scramblers" do
    assert scrambled({:swap_position, 1, 4}, "elixir") == "eiixlr"
    assert scrambled({:rotate, "right", 4}, "elixir") == "ixirel"
    assert scrambled({:rotate, "left", 3}, "elixir") == "xireli"
    assert scrambled({:rotate_letter, "l"}, "elixir") == "irelix"
    assert scrambled({:rotate_letter, "r"}, "elixir") == "relixi"
    assert scrambled({:reverse_position, 1, 3}, "elixir") == "exilir"
    assert scrambled({:move_position, 1, 3}, "elixir") == "eixlir"
  end

  test "example" do
    assert scrambled({:swap_position, 4, 0}, "abcde") == "ebcda"
    assert scrambled({:swap_letter, "d", "b"}, "ebcda") == "edcba"
    assert scrambled({:reverse_position, 0, 4}, "edcba") == "abcde"
    assert scrambled({:rotate, "left", 1}, "abcde") == "bcdea"
    assert scrambled({:move_position, 1, 4}, "bcdea") == "bdeac"
    assert scrambled({:move_position, 3, 0}, "bdeac") == "abdec"
    assert scrambled({:rotate_letter, "b"}, "abdec") == "ecabd"
    assert scrambled({:rotate_letter, "d"}, "ecabd") == "decab"
  end

  test "scramble" do
    assert scramble_string("abcde", """
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
    """) == "decab"
  end

  defp scrambled(instruction, string) do
    scramble(instruction, String.graphemes(string)) |> Enum.join("")
  end
end
