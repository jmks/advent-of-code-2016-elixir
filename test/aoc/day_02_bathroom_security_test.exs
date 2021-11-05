defmodule AoC.Day02BathroomSecurityTest do
  use ExUnit.Case

  import AoC.Day02BathroomSecurity
  alias AoC.Day02BathroomSecurity.{CrazyKeypad, StandardKeypad}

  test "bathroom_code" do
    instructions = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """

    assert bathroom_code(StandardKeypad, instructions) == "1985"
    assert bathroom_code(CrazyKeypad, instructions) == "5DB3"
  end
end
