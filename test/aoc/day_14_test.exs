defmodule AoC.Day14Test do
  use ExUnit.Case

  import AoC.Day14OTP

  test "generate_keys" do
    assert generate_keys("abc", 2) == [
      {39, "347dac6ee8eeea4652c7476d0f97bee5"},
      {92, "ae2e85dd75d63e916a525df95e999ea0"}
    ]
  end

  test "nth_key_index" do
    assert nth_key_index("abc", 64) == 22728
  end
end
