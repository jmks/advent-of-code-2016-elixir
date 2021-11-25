defmodule AoC.Day21Scramble do
  @moduledoc """
  --- Day 21: Scrambled Letters and Hash ---

  The computer system you're breaking into uses a weird scrambling function to store its passwords. It shouldn't be much trouble to create your own scrambled password so you can add it to the system; you just have to implement the scrambler.

  The scrambling function is a series of operations (the exact list is provided in your puzzle input). Starting with the password to be scrambled, apply each operation in succession to the string. The individual operations behave as follows:

  swap position X with position Y means that the letters at indexes X and Y (counting from 0) should be swapped.
  swap letter X with letter Y means that the letters X and Y should be swapped (regardless of where they appear in the string).
  rotate left/right X steps means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
  rotate based on position of letter X means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
  reverse positions X through Y means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
  move position X to position Y means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.

  For example, suppose you start with abcde and perform the following operations:

  swap position 4 with position 0 swaps the first and last letters, producing the input for the next step, ebcda.
  swap letter d with letter b swaps the positions of d and b: edcba.
  reverse positions 0 through 4 causes the entire string to be reversed, producing abcde.
  rotate left 1 step shifts all letters left one position, causing the first letter to wrap to the end of the string: bcdea.
  move position 1 to position 4 removes the letter at position 1 (c), then inserts it at position 4 (the end of the string): bdeac.
  move position 3 to position 0 removes the letter at position 3 (a), then inserts it at position 0 (the front of the string): abdec.
  rotate based on position of letter b finds the index of letter b (1), then rotates the string right once plus a number of times equal to that index (2): ecabd.
  rotate based on position of letter d finds the index of letter d (4), then rotates the string right once, plus a number of times equal to that index, plus an additional time because the index was at least 4, for a total of 6 right rotations: decab.

  After these steps, the resulting scrambled password is decab.

  Now, you just need to generate a new scrambled password and you can access the system. Given the list of scrambling operations in your puzzle input, what is the result of scrambling abcdefgh?
  """
  def scramble_string(start, instructions) do
    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> Enum.reduce(String.graphemes(start), &scramble/2)
    |> Enum.join("")
  end

  def scramble({:swap_position, index1, index2}, list) do
    one = Enum.at(list, index1)
    two = Enum.at(list, index2)

    list
    |> List.replace_at(index1, two)
    |> List.replace_at(index2, one)
  end

  def scramble({:swap_letter, one, two}, list) do
    Enum.map(list, fn
      ^one -> two
      ^two -> one
      other -> other
    end)
  end

  def scramble({:reverse_position, one, two}, list) do
    prefix = list |> Enum.take(one)
    reverse = list |> Enum.drop(one) |> Enum.take(two - one + 1)
    suffix = list |> Enum.drop(length(prefix) + length(reverse))

    prefix ++ Enum.reverse(reverse) ++ suffix
  end

  def scramble({:rotate_letter, letter}, list) do
    index = Enum.find_index(list, fn x -> x == letter end)

    rotations = index + 1
    rotations = if index >= 4, do: rotations + 1, else: rotations
    rotations = rem(rotations, length(list))

    rotate(:right, list, rotations)
  end

  def scramble({:rotate, "left", amount}, list) do
    rotate(:left, list, amount)
  end

  def scramble({:rotate, "right", amount}, list) do
    rotate(:right, list, amount)
  end

  def scramble({:move_position, from, to}, list) do
    char = Enum.at(list, from)

    list
    |> List.delete_at(from)
    |> List.insert_at(to, char)
  end

  defp parse("swap position" <> rest) do
    [one, two] = next_integers(rest)

    {:swap_position, one, two}
  end

  defp parse("swap letter " <> rest) do
    [one, _with, _letter, two] = String.split(rest, " ", trim: true)

    {:swap_letter, one, two}
  end

  defp parse("reverse positions" <> rest) do
    [one, two] = next_integers(rest)

    {:reverse_position, one, two}
  end

  defp parse("rotate based on position of letter " <> letter) do
    {:rotate_letter, letter}
  end

  defp parse("rotate" <> rest) do
    [direction, amount, _steps] = String.split(rest, " ", trim: true)

    {:rotate, direction, String.to_integer(amount)}
  end

  defp parse("move position" <> rest) do
    [one, two] = next_integers(rest)

    {:move_position, one, two}
  end

  defp next_integers(string) do
    Regex.scan(~r/(\d+)/, string)
    |> Enum.map(fn [int, _]  -> int end)
    |> Enum.map(&String.to_integer/1)
  end

  defp rotate(direction, list, times \\ 1)

  defp rotate(_, list, 0), do: list

  defp rotate(:right, list, times) do
    tail = Enum.take(list, length(list) - 1)

    rotate(:right, [List.last(list) | tail], times - 1)
  end

  defp rotate(:left, [h | t], times) do
    rotate(:left, t ++ [h], times - 1)
  end
end
