defmodule AoC.Day05ChessTest do
  use ExUnit.Case

  import AoC.Day05Chess

  test "password" do
    assert password("abc") == "18f47a30"
    # assert password("uqwqemis") == "1a3099aa"
  end
end
