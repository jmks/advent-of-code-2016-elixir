defmodule AoC.Day03SquareWithThreeSides do
  @moduledoc """
  --- Day 3: Squares With Three Sides ---
  Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.

  Or are they?

  The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.

  In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.

  In your puzzle input, how many of the listed triangles are possible?

  --- Part Two ---

  Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.

  For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:

  101 301 501
  102 302 502
  103 303 503
  201 401 601
  202 402 602
  203 403 603

  In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?
  """

  def possible_triangles(input) do
    input
    |> numberize()
    |> Enum.count(&possible_triangle?/1)
  end

  def possible_vertical_triangles(input) do
    input
    |> numberize()
    |> Enum.chunk_every(3)
    |> Enum.flat_map(&Enum.zip/1)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.count(&possible_triangle?/1)
  end

  def possible_triangle?(sides) do
    [small, med, large] = Enum.sort(sides)

    small + med > large
  end

  defp numberize(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      str |> String.split(~r/\s+/, trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end
end
