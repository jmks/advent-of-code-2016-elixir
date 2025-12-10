defmodule AoC.Day24Spurlunking do
  @moduledoc """
  --- Day 24: Air Duct Spelunking ---

  You've finally met your match; the doors that provide access to the roof are locked tight, and all of the controls and related electronics are inaccessible. You simply can't reach them.

  The robot that cleans the air ducts, however, can.

  It's not a very fast little robot, but you reconfigure it to be able to interface with some of the exposed wires that have been routed through the HVAC system. If you can direct it to each of those locations, you should be able to bypass the security controls.

  You extract the duct layout for this area from some blueprints you acquired and create a map with the relevant locations marked (your puzzle input). 0 is your current location, from which the cleaning robot embarks; the other numbers are (in no particular order) the locations the robot needs to visit at least once each. Walls are marked as #, and open passages are marked as .. Numbers behave like open passages.

  For example, suppose you have a map like the following:

  ###########
  #0.1.....2#
  #.#######.#
  #4.......3#
  ###########

  To reach all of the points of interest as quickly as possible, you would have the robot take the following path:

  0 to 4 (2 steps)
  4 to 1 (4 steps; it can't move diagonally)
  1 to 2 (6 steps)
  2 to 3 (2 steps)
  Since the robot isn't very fast, you need to find it the shortest route. This path is the fewest steps (in the above example, a total of 14) required to start at 0 and then visit every other location at least once.

  Given your actual map, and starting from location 0, what is the fewest number of steps required to visit every non-0 number marked on the map at least once?
  """
  defmodule Maze do
    defstruct [:coordinates, :poi, :x_range, :y_range]

    def parse(instructions) do
      coordinates =
        instructions
        |> String.split("\n", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {row, y}, map ->
          row
          |> String.graphemes()
          |> Enum.map(fn
            "#" -> :closed
            "." -> :open
            num -> String.to_integer(num)
          end)
          |> Enum.with_index()
          |> Enum.map(fn {state, x} -> {{x, y}, state} end)
          |> Enum.into(map)
        end)

      {{xmin, _}, {xmax, _}} = Map.keys(coordinates) |> Enum.min_max_by(fn {x, _y} -> x end)
      {{_, ymin}, {_, ymax}} = Map.keys(coordinates) |> Enum.min_max_by(fn {_x, y} -> y end)

      poi =
        coordinates
        |> Enum.filter(fn {{_, _}, state} -> is_integer(state) end)
        |> Enum.map(fn {coord, state} -> {state, coord} end)
        |> Enum.into(%{})

      %__MODULE__{
        coordinates: coordinates,
        x_range: xmin..xmax,
        y_range: ymin..ymax,
        poi: poi
      }
    end

    def open?(maze, coordinate) do
      case Map.get(maze.coordinates, coordinate) do
        :closed -> false
        _ -> true
      end
    end

    def shortest_distance(maze, start, destination) do
      start_coord = Map.get(maze.poi, start)
      dest_coord = Map.get(maze.poi, destination)
      state = {maze, start_coord, dest_coord, :infinity, MapSet.new()}

      do_shortest_path([state]) |> MapSet.size()
    end

    def adjacent_coordinates(maze, {x, y}) do
      [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1}
      ]
      |> Enum.filter(fn coord ->
        case Map.get(maze.coordinates, coord) do
          :open -> true
          num when is_integer(num) -> true
          _ -> false
        end
      end)
    end

    defp do_shortest_path([]), do: raise("no path found!")

    defp do_shortest_path([{_maze, destination, destination, _max, history} | _rest]) do
      history
    end

    defp do_shortest_path([{_maze, _current, _destination, 0, _history} | _rest]), do: []

    defp do_shortest_path([{maze, current, destination, max, history} | rest]) do
      # IO.inspect([current: current, history: history])
      adjacent = adjacent_coordinates(maze, current)

      new_max =
        case max do
          :infinity -> :infinity
          n -> n - 1
        end

      new_states =
        adjacent
        |> Enum.filter(fn coordinate -> not MapSet.member?(history, coordinate) end)
        |> Enum.map(fn coordinate ->
          {maze, coordinate, destination, new_max, MapSet.put(history, current)}
        end)

      do_shortest_path(rest ++ new_states)
    end
  end

  defimpl Inspect, for: Maze do
    def inspect(maze, _opts) do
      for y <- maze.y_range do
        for x <- maze.x_range do
          case Map.get(maze.coordinates, {x, y}) do
            :open -> "."
            :closed -> "#"
            num -> num
          end
        end
        |> Enum.join("")
      end
      |> Enum.join("\n")
    end
  end

  defmodule PoIMemo do
    use Agent

    def start_link(maze) do
      Agent.start_link(fn -> {maze, %{}} end)
    end

    def shortest_distance(pid, hi, lo) when hi > lo do
      shortest_distance(pid, lo, hi)
    end

    def shortest_distance(pid, lo, hi) do
      {maze, memo} = Agent.get(pid, & &1)

      if rem(map_size(memo), 10) == 0 do
        IO.puts("Cache now has #{map_size(memo)} elements")
      end

      case Map.fetch(memo, {lo, hi}) do
        {:ok, dist} ->
          dist

        :error ->
          distance = Maze.shortest_distance(maze, lo, hi)
          new_memo = Map.put(memo, {lo, hi}, distance)

          Agent.update(pid, fn _ -> {maze, new_memo} end)

          distance
      end
    end
  end

  def fewest_steps(instructions) do
    maze = Maze.parse(instructions) |> IO.inspect
    {:ok, memo} = PoIMemo.start_link(maze)
    paths =
      maze.poi
      |> Map.keys()
      |> List.delete(0) # start at 0
      |> permutations()
      |> Enum.map(fn path -> [0 | path] end)

    # precompute_paths(maze, Map.keys(maze.poi))

    IO.puts("#{length paths} paths")

    # TODO: the distance causes a HUGE branching factor, so
    # BFS may be infeasible.
    # Look into a CSP or backtracking alg
    paths
    |> Enum.map(&length_of_path(&1, memo, 0))
    |> Enum.min()
  end

  def length_of_path([a, b | rest], memo, len) do
    IO.puts("Calculating #{a} to #{b}")
    dist = PoIMemo.shortest_distance(memo, a, b)

    IO.puts("#{a} to #{b} is #{dist}")

    length_of_path([b | rest], memo, dist + len)
  end

  def length_of_path(_, _, len), do: len

  def permutations([]), do: []
  def permutations([a]), do: [a]
  def permutations([a, b]), do: [[a, b], [b, a]]
  def permutations(elements) do
    for element <- elements do
      for perm <- permutations(List.delete(elements, element)) do
        [element | perm]
      end
    end |> List.flatten() |> Enum.chunk_every(length(elements))
  end
end
