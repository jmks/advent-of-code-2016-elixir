defmodule AoC.Day20Test do
  use ExUnit.Case

  import AoC.Day22Grid
  alias AoC.Day22Grid.Node

  test "parse" do
    assert parse("some header\nstuff\n/dev/grid/node-x0-y0     85T   64T    21T   75%") ==
             [%Node{x: 0, y: 0, size: 85, used: 64, available: 21}]
  end
end
