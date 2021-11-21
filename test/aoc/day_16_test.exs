defmodule AoC.Day16Test do
  use ExUnit.Case

  import AoC.Day16Dragon

  test "expand" do
    assert expand("1") == "100"
    assert expand("0") == "001"
    assert expand("11111") == "11111000000"
    assert expand("111100001010") == "1111000010100101011110000"
  end

  test "checksume" do
    assert checksum("110010110100") == "100"
  end

  test "fill" do
    assert fill("10000", 20) == {"10000011110010000111", "01100"}
  end
end
