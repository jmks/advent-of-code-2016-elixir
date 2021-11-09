defmodule AoC.Day09Explosives do
  @moduledoc """
  --- Day 9: Explosives in Cyberspace ---
  Wandering around a secure area, you come across a datalink port to a new part of the network. After briefly scanning it for interesting files, you find one file in particular that catches your attention. It's compressed with an experimental format, but fortunately, the documentation for the format is nearby.

  The format compresses a sequence of characters. Whitespace is ignored. To indicate that some sequence should be repeated, a marker is added to the file, like (10x2). To decompress this marker, take the subsequent 10 characters and repeat them 2 times. Then, continue reading the file after the repeated data. The marker itself is not included in the decompressed output.

  If parentheses or other characters appear within the data referenced by a marker, that's okay - treat it like normal data, not a marker, and then resume looking for markers after the decompressed section.

  For example:

  ADVENT contains no markers and decompresses to itself with no changes, resulting in a decompressed length of 6.
  A(1x5)BC repeats only the B a total of 5 times, becoming ABBBBBC for a decompressed length of 7.
  (3x3)XYZ becomes XYZXYZXYZ for a decompressed length of 9.
  A(2x2)BCD(2x2)EFG doubles the BC and EF, becoming ABCBCDEFEFG for a decompressed length of 11.
  (6x1)(1x3)A simply becomes (1x3)A - the (1x3) looks like a marker, but because it's within a data section of another marker, it is not treated any differently from the A that comes after it. It has a decompressed length of 6.
  X(8x2)(3x3)ABCY becomes X(3x3)ABC(3x3)ABCY (for a decompressed length of 18), because the decompressed data from the (8x2) marker (the (3x3)ABC) is skipped and not processed further.

  What is the decompressed length of the file (your puzzle input)? Don't count whitespace.
  """

  def decompress(compressed) do
    do_decompress(String.graphemes(compressed), [])
  end

  defp do_decompress([], decompressed), do: decompressed |> Enum.reverse() |> Enum.join("")

  defp do_decompress(["(" | rest], acc) do
    {chars, rest} = read_number(rest)
    ["x" | rest] = rest
    {times, rest} = read_number(rest)
    [")" | rest] = rest

    str = rest |> Enum.take(chars) |> Enum.join("")
    rest = rest |> Enum.drop(chars)

    do_decompress(rest, [repeat(str, times) | acc])
  end

  defp do_decompress([char | rest], acc) do
    do_decompress(rest, [char | acc])
  end

  defp read_number(chars), do: do_read_number(chars, [])

  defp do_read_number([number | rest], acc) when number in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
    do_read_number(rest, [number | acc])
  end

  defp do_read_number(rest, acc) do
    number = acc |> Enum.reverse() |> Enum.join("") |> String.to_integer()

    {number, rest}
  end

  defp repeat(str, repetitions) do
    1..repetitions
    |> Enum.map(fn _ -> str end)
    |> Enum.join("")
  end
end
