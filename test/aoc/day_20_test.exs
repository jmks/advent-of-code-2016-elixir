defmodule AoC.Day20Test do
  use ExUnit.Case

  import AoC.Day20Firewall

  test "lowest_allowed" do
    # 5721363
    assert lowest_allowed("""
           5-8
           0-2
           4-7
           """) == 3
  end
end
