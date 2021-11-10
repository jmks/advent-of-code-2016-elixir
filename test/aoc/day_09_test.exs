defmodule AoC.Day09Test do
  use ExUnit.Case

  import AoC.Day09Explosives

  test "decompress" do
    assert decompress("ADVENT") == "ADVENT"
    assert decompress("A(1x5)BC") == "ABBBBBC"
    assert decompress("(3x3)XYZ") == "XYZXYZXYZ"
    assert decompress("(6x1)(1x3)A") == "(1x3)A"
    assert decompress("X(8x2)(3x3)ABCY") == "X(3x3)ABC(3x3)ABCY"
  end

  test "decompressed_length" do
    assert decompressed_length(:v2, "(3x3)XYZ") == 9
    assert decompressed_length(:v2, "X(8x2)(3x3)ABCY") == 20
    assert decompressed_length(:v2, "(27x12)(20x12)(13x14)(7x10)(1x12)A") == 241920
    assert decompressed_length(:v2, "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN") == 445
  end
end
