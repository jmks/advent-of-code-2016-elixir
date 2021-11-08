defmodule AoC.Day06SignalsAndNoise do
  @moduledoc """
  --- Day 6: Signals and Noise ---
  Something is jamming your communications with Santa. Fortunately, your signal is only partially jammed, and protocol in situations like this is to switch to a simple repetition code to get the message through.

  In this model, the same message is sent repeatedly. You've recorded the repeating message signal (your puzzle input), but the data seems quite corrupted - almost too badly to recover. Almost.

  All you need to do is figure out which character is most frequent for each position. For example, suppose you had recorded the following messages:

  eedadn
  drvtee
  eandsr
  raavrd
  atevrs
  tsrnev
  sdttsa
  rasrtv
  nssdts
  ntnada
  svetve
  tesnvt
  vntsnd
  vrdear
  dvrsen
  enarar

  The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.

  Given the recording in your puzzle input, what is the error-corrected version of the message being sent?
  """

  def error_correcting_code(input) do
    input
    |> character_frequencies()
    |> Enum.map(&most_frequent_character/1)
    |> Enum.join("")
  end

  def original_message(input) do
    input
    |> character_frequencies()
    |> Enum.map(&least_frequent_character/1)
    |> Enum.join("")
  end

  defp character_frequencies(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Enum.frequencies(Tuple.to_list(&1)))
  end

  defp most_frequent_character(frequencies) do
    {char, _count} = Enum.max_by(frequencies, fn {_char, count} -> count end)

    char
  end

  defp least_frequent_character(frequencies) do
    {char, _count} = Enum.min_by(frequencies, fn {_char, count} -> count end)

    char
  end
end
