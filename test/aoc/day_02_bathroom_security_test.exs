defmodule AoC.Day02BathroomSecurityTest do
  use ExUnit.Case

  import AoC.Day02BathroomSecurity

  test "bathroom_code" do
    instructions = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """

    assert bathroom_code(instructions) == "1985"
  end
end
