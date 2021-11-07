defmodule AoC.Day03SquareWithThreeSides do
  @moduledoc """
  --- Day 3: Squares With Three Sides ---
  Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.

  Or are they?

  The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.

  In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.

  In your puzzle input, how many of the listed triangles are possible?
  """

  def possible_triangles(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      str |> String.split(~r/\s+/, trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.count(&possible_triangle?/1)
  end

  def possible_triangle?(sides) do
    [small, med, large] = Enum.sort(sides)

    small + med > large
  end
end
