defmodule AoC.Day01NoTime do
  @moduledoc """
  --- Day 1: No Time for a Taxicab ---

  Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

  You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.

  The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.

  There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?

  For example:

  Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
  R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
  R5, L5, R5, R3 leaves you 12 blocks away.

  How many blocks away is Easter Bunny HQ?

  --- Part Two ---

  Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first location you visit twice.

  For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.

  How many blocks away is the first location you visit twice?
  """
  def parse_directions(directions) do
    directions
    |> String.split(", ")
    |> Enum.map(fn
      "L" <> distance ->
        {:left, String.to_integer(distance)}

      "R" <> distance ->
        {:right, String.to_integer(distance)}
    end)
  end

  def blocks_away(directions) do
    # {facing, blocks_north, blocks_east}
    start = {:north, 0, 0}

    {_facing, northward, eastward} =
      Enum.reduce(
        parse_directions(directions),
        start,
        fn {dir, distance}, {facing, northward, eastward} ->
          new_dir = new_direction(facing, dir)
          {north_delta, east_delta} = distance_delta(new_dir, distance)

          {new_dir, northward + north_delta, eastward + east_delta}
        end
      )

    abs(northward) + abs(eastward)
  end

  def first_visited_twice(directions) do
    start = {:north, 0, 0}
    visited = MapSet.new

    {northward, eastward} = do_first_visited_twice(parse_directions(directions), start, visited)

    abs(northward) + abs(eastward)
  end

  defp new_direction(:north, :right), do: :east
  defp new_direction(:north, :left), do: :west
  defp new_direction(:east, :right), do: :south
  defp new_direction(:east, :left), do: :north
  defp new_direction(:west, :right), do: :north
  defp new_direction(:west, :left), do: :south
  defp new_direction(:south, :right), do: :west
  defp new_direction(:south, :left), do: :east

  defp distance_delta(:north, distance), do: {distance, 0}
  defp distance_delta(:east, distance), do: {0, distance}
  defp distance_delta(:south, distance), do: {-distance, 0}
  defp distance_delta(:west, distance), do: {0, -distance}

  # Example: R8, R4, R4, R8
  #    4
  #    .
  #    .
  #    .
  # s..x...1
  #    .   .
  #    .   .
  #    .   .
  #    3...2
  defp do_first_visited_twice([{dir, distance} | directions], {facing, northward, eastward}, visited) do
    new_dir = new_direction(facing, dir)
    {north_delta, east_delta} = distance_delta(new_dir, distance)

    newly_visited = coordinates_travelled({northward, eastward}, {north_delta, east_delta})
    already_visited = Enum.find(newly_visited, &MapSet.member?(visited, &1))

    if already_visited do
      already_visited
    else
      new_position = {new_dir, northward + north_delta, eastward + east_delta}
      new_visited = MapSet.union(visited, MapSet.new(newly_visited))

      do_first_visited_twice(directions, new_position, new_visited)
    end
  end

  defp coordinates_travelled({north, eastward}, {0, east}) do
    for i <- (eastward + sign(east))..(eastward + east), do: {north, i}
  end

  defp coordinates_travelled({northward, east}, {north, 0}) do
    for i <- (northward + sign(north))..(northward + north), do: {i, east}
  end

  defp sign(int), do: div(int, abs(int))
end
