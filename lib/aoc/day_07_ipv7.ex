defmodule AoC.Day07Ipv7 do
  @moduledoc """
  --- Day 7: Internet Protocol Version 7 ---
  While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).

  An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.

  For example:

  abba[mnop]qrst supports TLS (abba outside square brackets).
  abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
  aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
  ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).

  How many IPs in your puzzle input support TLS?

  --- Part Two ---

  You would also like to know which IPs support SSL (super-secret listening).

  An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.

  For example:

  aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
  xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
  aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
  zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).

  How many IPs in your puzzle input support SSL?
  """
  def support_tls_count(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.count(&supports_tls?/1)
  end

  def support_ssl_count(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.count(&supports_ssl?/1)
  end

  def supports_tls?(ip) do
    supernet_abba?(ip) and not hypernet_abba?(ip)
  end

  def supports_ssl?(ip) do
    abas = supernet_abas(ip)
    babs = hypernet_babs(ip)

    not MapSet.disjoint?(
      MapSet.new(corresponding_babs(abas)),
      MapSet.new(babs)
    )
  end

  defp supernet_abba?(ip) do
    ip
    |> supernet_parts()
    |> Enum.any?(&abba?/1)
  end

  defp supernet_abas(ip) do
    ip
    |> supernet_parts()
    |> Enum.flat_map(&aba/1)
  end

  defp hypernet_babs(ip) do
    ip
    |> hypernet_parts()
    |> Enum.flat_map(&aba/1)
  end

  defp supernet_parts(ip) do
    ip
    |> String.replace(~r/\[[a-z]+\]/, "-")
    |> String.split("-")
  end

  defp hypernet_abba?(ip) do
    ip
    |> hypernet_parts()
    |> Enum.any?(&abba?/1)
  end

  defp hypernet_parts(ip) do
    Regex.scan(~r/\[([a-z]+)\]/, ip) |> Enum.map(&List.last/1)
  end

  defp string_patterns(string, chunk_size, pattern_filter) do
    string
    |> String.graphemes()
    |> chunks(chunk_size)
    |> Enum.filter(pattern_filter)
  end

  defp abba?(string) do
    string_patterns(string, 4, fn
      [a, b, b, a] -> a != b
      _ -> false
    end)
    |> Enum.any?
  end

  defp aba(string) do
    string_patterns(string, 3, fn
      [a, b, a] -> a != b
      _ -> false
    end)
  end

  defp chunks(list, size) do
    do_chunks(list, size, [])
  end

  defp do_chunks(characters, size, acc) do
    chunk = Enum.take(characters, size)

    if length(chunk) == size do
      do_chunks(tl(characters), size, [chunk | acc])
    else
      acc
    end
  end

  defp corresponding_babs(abas) do
    Enum.map(abas, fn [a, b, a] -> [b, a, b] end)
  end
end
