defmodule AoC.Day20Test do
  use ExUnit.Case

  import AoC.Day20Firewall

  test "lowest_allowed" do
    assert lowest_allowed("""
           5-8
           0-2
           4-7
           """) == 3
  end

  test "ips_allowed" do
    assert ips_allowed("""
    5-8
    0-2
    4-7
    """, 9) == 2
  end
end
