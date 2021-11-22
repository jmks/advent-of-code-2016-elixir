defmodule AoC.Day17TwoSteps do
  @moduledoc """
  --- Day 17: Two Steps Forward ---

  You're trying to access a secure vault protected by a 4x4 grid of small rooms connected by doors. You start in the top-left room (marked S), and you can access the vault (marked V) once you reach the bottom-right room:

  #########
  #S| | | #
  #-#-#-#-#
  # | | | #
  #-#-#-#-#
  # | | | #
  #-#-#-#-#
  # | | |
  ####### V
  Fixed walls are marked with #, and doors are marked with - or |.

  The doors in your current room are either open or closed (and locked) based on the hexadecimal MD5 hash of a passcode (your puzzle input) followed by a sequence of uppercase characters representing the path you have taken so far (U for up, D for down, L for left, and R for right).

  Only the first four characters of the hash are used; they represent, respectively, the doors up, down, left, and right from your current position. Any b, c, d, e, or f means that the corresponding door is open; any other character (any number or a) means that the corresponding door is closed and locked.

  To access the vault, all you need to do is reach the bottom-right room; reaching this room opens the vault and all doors in the maze.

  For example, suppose the passcode is hijkl. Initially, you have taken no steps, and so your path is empty: you simply find the MD5 hash of hijkl alone. The first four characters of this hash are ced9, which indicate that up is open (c), down is open (e), left is open (d), and right is closed and locked (9). Because you start in the top-left corner, there are no "up" or "left" doors to be open, so your only choice is down.

  Next, having gone only one step (down, or D), you find the hash of hijklD. This produces f2bc, which indicates that you can go back up, left (but that's a wall), or right. Going right means hashing hijklDR to get 5745 - all doors closed and locked. However, going up instead is worthwhile: even though it returns you to the room you started in, your path would then be DU, opening a different set of doors.

  After going DU (and then hashing hijklDU to get 528e), only the right door is open; after going DUR, all doors lock. (Fortunately, your actual passcode is not hijkl).

  Passcodes actually used by Easter Bunny Vault Security do allow access to the vault if you know the right path. For example:

  If your passcode were ihgpwlah, the shortest path would be DDRRRD.
  With kglvqrro, the shortest path would be DDUDRLRRUDRD.
  With ulqzkmiv, the shortest would be DRURDRUDDLLDLUURRDULRLDUUDDDRR.

  Given your vault's passcode, what is the shortest path (the actual path, not just the length) to reach the vault?
  """
  defmodule Map do
    defstruct [:position]

    def new(start) do
      %__MODULE__{position: start}
    end

    def doors(map) do
      {x, y} = map.position

      vertical_doors(x) ++ horizontal_doors(y)
    end

    def exit?(map) do
      map.position == {4, 4}
    end

    # Assumes called with valid door to walk through
    def move(%{position: {x, y}}, :up), do: new({x - 1, y})
    def move(%{position: {x, y}}, :down), do: new({x + 1, y})
    def move(%{position: {x, y}}, :left), do: new({x, y - 1})
    def move(%{position: {x, y}}, :right), do: new({x, y + 1})

    defp vertical_doors(1), do: [:down]
    defp vertical_doors(4), do: [:up]
    defp vertical_doors(_), do: [:up, :down]

    defp horizontal_doors(1), do: [:right]
    defp horizontal_doors(4), do: [:left]
    defp horizontal_doors(_), do: [:right, :left]
  end

  def shortest_path(passcode) do
    map = Map.new({1, 1})

    state = {map, passcode, []}

    do_shortest_path([state])
  end

  def door_states(passcode, path) do
    passcode <> Enum.join(path, "")
    |> md5()
    |> String.slice(0, 4)
    |> String.graphemes()
    |> Enum.map(&hex_state/1)
    |> Enum.zip([:up, :down, :left, :right])
    |> Enum.map(fn {state, door} -> {door, state} end)
  end

  def door_open?(passcode, path, direction) do
    states = door_states(passcode, path)

    states[direction] == :open
  end

  defp md5(string) do
    :crypto.hash(:md5, string) |> Base.encode16(case: :lower)
  end

  defp hex_state(char) do
    if char in ~w(b c d e f) do
      :open
    else
      :closed
    end
  end

  defp do_shortest_path([]), do: raise("Out of states!")

  defp do_shortest_path([{map, code, history} | states]) do
    if Map.exit?(map) do
      history |> Enum.reverse() |> Enum.join("")
    else
      new_states =
        map
        |> Map.doors()
        |> Enum.filter(&door_open?(code, Enum.reverse(history), &1))
        |> Enum.map(fn door -> {Map.move(map, door), code, [door_path(door) | history]} end)

      do_shortest_path(states ++ new_states)
    end
  end

  defp door_path(:up), do: "U"
  defp door_path(:down), do: "D"
  defp door_path(:left), do: "L"
  defp door_path(:right), do: "R"
end
