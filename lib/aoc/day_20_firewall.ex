defmodule AoC.Day20Firewall do
  @moduledoc """
  --- Day 20: Firewall Rules ---

  You'd like to set up a small hidden computer here so you can use it to get back into the network later. However, the corporate firewall only allows communication with certain external IP addresses.

  You've retrieved the list of blocked IPs from the firewall, but the list seems to be messy and poorly maintained, and it's not clear which IPs are allowed. Also, rather than being written in dot-decimal notation, they are written as plain 32-bit integers, which can have any value from 0 through 4294967295, inclusive.

  For example, suppose only the values 0 through 9 were valid, and that you retrieved the following blacklist:

  5-8
  0-2
  4-7

  The blacklist specifies ranges of IPs (inclusive of both the start and end value) that are not allowed. Then, the only IPs that this firewall allows are 3 and 9, since those are the only numbers not in any range.

  Given the list of blocked IPs you retrieved from the firewall (your puzzle input), what is the lowest-valued IP that is not blocked?

  --- Part Two ---

  How many IPs are allowed by the blacklist?
  """
  defmodule Parser do
    import NimbleParsec

    defparsec :ip_range,
      integer(min: 1)
      |> ignore(string("-"))
      |> integer(min: 1)
  end

  def lowest_allowed(rules) do
    rules
    |> sorted_rules()
    |> lowest(0)
  end

  def ips_allowed(rules, max) do
    rules
    |> sorted_rules()
    |> count(0, max, 0)
  end

  defp sorted_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(&Parser.ip_range/1)
    |> Enum.map(fn {:ok, [min, max], _, _, _, _} ->
      {min, max}
    end)
    |> Enum.sort_by(fn {min, _max} -> min end)
  end

  defp lowest([{min, _max} | _rest], low) when low < min, do: low

  defp lowest([{_min, max} | rest], low) do
    lowest(rest, Enum.max([low, max + 1]))
  end

  defp count([], ip, maximum, total) do
    if ip > maximum do
      total
    else
      maximum - ip + 1 + total
    end
  end

  defp count(rules = [{min, max} | rest], ip, maximum, total) when ip < min do
    count(rules, ip + 1, maximum, total + 1)
  end

  defp count([{_min, max} | rest], ip, maximum, total) do
    count(rest, Enum.max([ip, max + 1]), maximum, total)
  end
end
