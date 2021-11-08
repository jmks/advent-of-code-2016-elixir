defmodule AoC.Day06SignalsAndNoiseTest do
  use ExUnit.Case

  import AoC.Day06SignalsAndNoise

  @example """
  eedadn
  drvtee
  eandsr
  raavrd
  atevrs
  tsrnev
  sdttsa
  rasrtv
  nssdts
  ntnada
  svetve
  tesnvt
  vntsnd
  vrdear
  dvrsen
  enarar
  """

  test "error_correcting_code" do
    assert error_correcting_code(@example) == "easter"
  end

  test "original_message" do
    assert original_message(@example) == "advent"
  end
end
