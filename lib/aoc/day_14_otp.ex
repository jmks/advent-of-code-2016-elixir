defmodule AoC.Day14OTP do
  @moduledoc """
  --- Day 14: One-Time Pad ---
  In order to communicate securely with Santa while you're on this mission, you've been using a one-time pad that you generate using a pre-agreed algorithm. Unfortunately, you've run out of keys in your one-time pad, and so you need to generate some more.

  To generate keys, you first get a stream of random data by taking the MD5 of a pre-arranged salt (your puzzle input) and an increasing integer index (starting with 0, and represented in decimal); the resulting MD5 hash should be represented as a string of lowercase hexadecimal digits.

  However, not all of these MD5 hashes are keys, and you need 64 new keys for your one-time pad. A hash is a key only if:

  It contains three of the same character in a row, like 777. Only consider the first such triplet in a hash.
  One of the next 1000 hashes in the stream contains that same character five times in a row, like 77777.
  Considering future hashes for five-of-a-kind sequences does not cause those hashes to be skipped; instead, regardless of whether the current hash is a key, always resume testing for keys starting with the very next hash.

  For example, if the pre-arranged salt is abc:

  The first index which produces a triple is 18, because the MD5 hash of abc18 contains ...cc38887a5.... However, index 18 does not count as a key for your one-time pad, because none of the next thousand hashes (index 19 through index 1018) contain 88888.
  The next index which produces a triple is 39; the hash of abc39 contains eee. It is also the first key: one of the next thousand hashes (the one at index 816) contains eeeee.
  None of the next six triples are keys, but the one after that, at index 92, is: it contains 999 and index 200 contains 99999.
  Eventually, index 22728 meets all of the criteria to generate the 64th key.
  So, using our example salt of abc, index 22728 produces the 64th key.

  Given the actual salt in your puzzle input, what index produces your 64th one-time pad key?
  """
  def generate_keys(salt, count \\ 64), do: do_generate_keys(salt, 0, count, [])

  def nth_key_index(salt, n) do
    salt
    |> generate_keys(n)
    |> List.last()
    |> elem(0)
  end

  def do_generate_keys(_salt, _index, count, keys) when length(keys) == count, do: Enum.reverse(keys)

  def do_generate_keys(salt, index, count, keys) do
    hash = md5(salt, index)

    case triplet(hash) do
      {:ok, char} ->
        target = List.duplicate(char, 5) |> Enum.join()
        if next_hashes_include_repeated?(target, salt, index + 1, 1_000) do
          do_generate_keys(salt, index + 1, count, [{index, hash} | keys])
        else
          do_generate_keys(salt, index + 1, count, keys)
        end

      :error ->
        do_generate_keys(salt, index + 1, count, keys)
    end
  end

  defp md5(salt, index) do
    :crypto.hash(:md5, salt <> Integer.to_string(index)) |> Base.encode16(case: :lower)
  end

  defp triplet(string) do
    string
    |> String.graphemes()
    |> do_triplet()
  end

  defp do_triplet(chars) when length(chars) < 3, do: :error
  defp do_triplet([a, a, a | _]), do: {:ok, a}
  defp do_triplet([_ | rest]), do: do_triplet(rest)

  defp next_hashes_include_repeated?(_needle, _salt, _index, 0), do: false

  defp next_hashes_include_repeated?(needle, salt, index, hashes) do
    hash = md5(salt, index)

    if String.contains?(hash, needle) do
      true
    else
      next_hashes_include_repeated?(needle, salt, index + 1, hashes - 1)
    end
  end
end
