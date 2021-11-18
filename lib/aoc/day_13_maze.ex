defmodule AoC.Day13Maze do
  @moduledoc """
  --- Day 13: A Maze of Twisty Little Cubicles ---
  You arrive at the first floor of this new building to discover a much less welcoming environment than the shiny atrium of the last one. Instead, you are in a maze of twisty little cubicles, all alike.

  Every location in this area is addressed by a pair of non-negative integers (x,y). Each such coordinate is either a wall or an open space. You can't move diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward positive x and y; negative values are invalid, as they represent a location outside the building. You are in a small waiting area at 1,1.

  While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite logical. You can determine whether a given x,y coordinate will be a wall or an open space using a simple system:

  Find x*x + 3*x + 2*x*y + y + y*y.
  Add the office designer's favorite number (your puzzle input).
  Find the binary representation of that sum; count the number of bits that are 1.
  If the number of bits that are 1 is even, it's an open space.
  If the number of bits that are 1 is odd, it's a wall.

  For example, if the office designer's favorite number were 10, drawing walls as # and open spaces as ., the corner of the building containing 0,0 would look like this:

    0123456789
  0 .#.####.##
  1 ..#..#...#
  2 #....##...
  3 ###.#.###.
  4 .##..#..#.
  5 ..##....#.
  6 #...##.###

  Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:

    0123456789
  0 .#.####.##
  1 .O#..#...#
  2 #OOO.##...
  3 ###O#.###.
  4 .##OO#OO#.
  5 ..##OOO.#.
  6 #...##.###

  Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).

  What is the fewest number of steps required for you to reach 31,39?
  """
  defmodule Maze do
    defstruct [:squares, :fav_number]

    def new(favourite_number) do
      maze = %__MODULE__{
        squares: %{},
        fav_number: favourite_number
      }

      {:ok, pid} = Agent.start_link(fn -> maze end)

      pid
    end

    def open_adjacent_squares(maze, coordinate) do
      neighbours = adjancent_squares(coordinate)
      calculate_open_coordinates(maze, neighbours)
    end

    def print(maze, visited \\ MapSet.new()) do
      max_x = Enum.max_by(maze.squares, fn {{x, _y}, _} -> x end) |> elem(0) |> elem(0)
      max_y = Enum.max_by(maze.squares, fn {{_x, y}, _} -> y end) |> elem(0) |> elem(1)
      max_y_digits = max_y |> Integer.to_string() |> String.length()

      grid =
        for y <- 0..max_y do
          row =
            for x <- 0..max_x do
              case Map.get(maze.squares, {x, y}) do
                nil -> "?"
                false -> "#"
                true -> if MapSet.member?(visited, {x, y}), do: "v", else: "."
              end
            end

          Enum.join([String.pad_leading(to_string(y), max_y_digits, "0"), " " | row], "")
        end

      [[" ", " " | Enum.into(0..max_x, []) |> Enum.map(&Integer.to_string/1)] | grid]
      |> Enum.join("\n")
    end

    defp adjancent_squares({x, y}) do
      [
        {x - 1, y},
        {x + 1, y},
        {x, y + 1},
        {x, y - 1}
      ]
      |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 end)
    end

    defp calculate_open_coordinates(maze, coordinates) do
      do_calculate_open_coordinates(maze, coordinates, [])
    end

    defp do_calculate_open_coordinates(_maze, [], open), do: open

    defp do_calculate_open_coordinates(maze, [coordinate | coordinates], open) do
      {squares, fav_number} = Agent.get(maze, &{&1.squares, &1.fav_number})

      cond do
        Map.get(squares, coordinate, false) ->
          do_calculate_open_coordinates(maze, coordinates, [coordinate | open])

        Map.has_key?(squares, coordinate) ->
          do_calculate_open_coordinates(maze, coordinates, open)

        true ->
          new_squares = Map.put_new(squares, coordinate, open?(coordinate, fav_number))

          Agent.update(maze, fn state ->
            struct!(state, squares: new_squares)
          end)

          do_calculate_open_coordinates(maze, [coordinate | coordinates], open)
      end
    end

    defp open?({x, y}, favourite_number) do
      number = x * x + 3 * x + 2 * x * y + y + y * y + favourite_number

      ones =
        number
        |> Integer.to_string(2)
        |> String.graphemes()
        |> Enum.count(fn digit -> digit == "1" end)

      rem(ones, 2) == 0
    end
  end

  defimpl Inspect, for: Maze do
    def inspect(maze, _opts) do
      Maze.print(maze)
    end
  end

  def shortest_path(maze, start_coordinate, destination_coordinate) do
    state = {maze, start_coordinate, destination_coordinate, MapSet.new()}

    do_shortest_path([state])
  end

  defp do_shortest_path([]), do: raise("No solution!")

  defp do_shortest_path([{_maze, destination, destination, history} | _rest]) do
    MapSet.size(history)
  end

  defp do_shortest_path([{maze, current, destination, history} | rest]) do
    adjacent = Maze.open_adjacent_squares(maze, current)

    new_states =
      adjacent
      |> Enum.filter(fn coordinate -> not MapSet.member?(history, coordinate) end)
      |> Enum.map(fn coordinate ->
        {maze, coordinate, destination, MapSet.put(history, current)}
      end)

    do_shortest_path(rest ++ new_states)
  end
end
