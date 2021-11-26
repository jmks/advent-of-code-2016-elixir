defmodule AoC.Day22Grid do
  @moduledoc """
  --- Day 22: Grid Computing ---

  You gain access to a massive storage cluster arranged in a grid; each storage node is only connected to the four nodes directly adjacent to it (three if the node is on an edge, two if it's in a corner).

  You can directly access data only on node /dev/grid/node-x0-y0, but you can perform some limited actions on the other nodes:

  You can get the disk usage of all nodes (via df). The result of doing this is in your puzzle input.
  You can instruct a node to move (not copy) all of its data to an adjacent node (if the destination node has enough space to receive the data). The sending node is left empty after this operation.
  Nodes are named by their position: the node named node-x10-y10 is adjacent to nodes node-x9-y10, node-x11-y10, node-x10-y9, and node-x10-y11.

  Before you begin, you need to understand the arrangement of data on these nodes. Even though you can only move data between directly connected nodes, you're going to need to rearrange a lot of the data to get access to the data you need. Therefore, you need to work out how you might be able to shift data around.

  To do this, you'd like to count the number of viable pairs of nodes. A viable pair is any two nodes (A,B), regardless of whether they are directly connected, such that:

  Node A is not empty (its Used is not zero).
  Nodes A and B are not the same node.
  The data on node A (its Used) would fit on node B (its Avail).

  How many viable pairs of nodes are there?
  """
  defmodule Node do
    defstruct [:x, :y, :size, :used, :available]

    def empty?(node) do
      node.used == 0
    end

    def same?(self, other) do
      self.x == other.x and self.y == other.y
    end
  end

  defmodule Parser do
    import NimbleParsec

    whitespace = repeat(string(" "))

    size =
      ignore(whitespace)
      |> integer(min: 1)
      |> ignore(string("T"))

    defparsec(
      :node,
      ignore(string("/dev/grid/node-x"))
      |> integer(min: 1)
      |> ignore(string("-y"))
      |> integer(min: 1)
      |> repeat(size)
    )
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.drop(2)
    |> Enum.map(&Parser.node/1)
    |> Enum.map(fn {:ok, [x, y, size, used, available], _, _, _, _} ->
      %Node{x: x, y: y, size: size, used: used, available: available}
    end)
  end

  def count_viable_pairs(input) do
    nodes = parse(input)
    by_used = Enum.sort_by(nodes, & &1.used, :asc)
    by_available = Enum.sort_by(nodes, & &1.available, :desc)

    do_count_viable_pairs(by_used, by_available, 0)
  end

  defp do_count_viable_pairs([], _, count), do: count

  defp do_count_viable_pairs([used | useds], by_available, count) do
    viable =
      by_available
      |> Enum.take_while(fn avail ->
        not Node.empty?(used) and not Node.same?(used, avail) and used.used <= avail.available
      end)
      |> length()

    do_count_viable_pairs(useds, by_available, viable + count)
  end
end
