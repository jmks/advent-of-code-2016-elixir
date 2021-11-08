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
  """
  def support_tls_count(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.count(&supports_tls?/1)
  end

  def supports_tls?(ip) do
    ip_abba?(ip) and not hypernet_abba?(ip)
  end

  defp ip_abba?(ip) do
    ip
    |> ip_parts()
    |> Enum.any?(&abba?/1)
  end

  defp ip_parts(ip) do
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

  defp abba?(string) do
    string
    |> String.graphemes()
    |> four_letter_chunks()
    |> Enum.filter(fn
      [a, b, b, a] -> a != b
      _ -> false
    end)
    |> Enum.any?()
  end

  defp four_letter_chunks(characters) do
    do_four_letter_chunks(characters, [])
  end

  defp do_four_letter_chunks(characters, acc) do
    chunk = Enum.take(characters, 4)

    if length(chunk) == 4 do
      do_four_letter_chunks(tl(characters), [chunk | acc])
    else
      acc
    end
  end
end
