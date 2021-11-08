defmodule AoC.Day05ChessTest do
  use ExUnit.Case

  import AoC.Day05Chess

  test "simple_password" do
    assert simple_password("abc") == "18f47a30"
  end

  test "complex_password" do
    assert complex_password("abc") == "05ace8e3"
  end
end
