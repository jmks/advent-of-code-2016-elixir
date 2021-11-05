defmodule AoC.Day02BathroomSecurityTest do
  use ExUnit.Case

  import AoC.Day02BathroomSecurity
  alias AoC.Day02BathroomSecurity.StandardKeypad

  test "bathroom_code" do
    instructions = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """

    assert bathroom_code(StandardKeypad, instructions) == "1985"
  end
end
