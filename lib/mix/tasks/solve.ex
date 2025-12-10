defmodule Mix.Tasks.Solve do
  use Mix.Task

  @impl Mix.Task
  def run([day]) do
    d = String.to_integer(day)
    data_filename = String.pad_leading(day, 2, "0")
    input = File.read!(Path.join([File.cwd!(), "data", data_filename]))

    Mix.shell().info("Solution for Day #{day}, part 1: #{inspect(solve(d, 1, input))}")
    Mix.shell().info("Solution for Day #{day}, part 2: #{inspect(solve(d, 2, input))}")
  end

  defp solve(day, part, input)

  defp solve(1, 1, input), do: AoC.Day01NoTime.blocks_away(input)
  defp solve(1, 2, input), do: AoC.Day01NoTime.first_visited_twice(input)

  defp solve(2, 1, input),
    do: AoC.Day02BathroomSecurity.bathroom_code(AoC.Day02BathroomSecurity.StandardKeypad, input)

  defp solve(2, 2, input),
    do: AoC.Day02BathroomSecurity.bathroom_code(AoC.Day02BathroomSecurity.CrazyKeypad, input)

  defp solve(3, 1, input), do: AoC.Day03SquareWithThreeSides.possible_triangles(input)
  defp solve(3, 2, input), do: AoC.Day03SquareWithThreeSides.possible_vertical_triangles(input)

  defp solve(4, 1, input), do: AoC.Day04SecurityThroughObscurity.sector_sum_of_valid_rooms(input)
  defp solve(4, 2, input), do: AoC.Day04SecurityThroughObscurity.find_north_pole(input)

  defp solve(5, 1, input), do: AoC.Day05Chess.simple_password(String.trim(input))
  defp solve(5, 2, input), do: AoC.Day05Chess.complex_password(String.trim(input))

  defp solve(6, 1, input), do: AoC.Day06SignalsAndNoise.error_correcting_code(input)
  defp solve(6, 2, input), do: AoC.Day06SignalsAndNoise.original_message(input)

  defp solve(7, 1, input), do: AoC.Day07Ipv7.support_tls_count(input)
  defp solve(7, 2, input), do: AoC.Day07Ipv7.support_ssl_count(input)

  defp solve(8, 1, input), do: AoC.Day08TwoFactor.pixels_on(input)
  defp solve(8, 2, input), do: AoC.Day08TwoFactor.display(input)

  defp solve(9, 1, input), do: AoC.Day09Explosives.decompress(input) |> String.length()
  defp solve(9, 2, input), do: AoC.Day09Explosives.decompressed_length(:v2, input)

  defp solve(10, 1, input), do: AoC.Day10Balance.who_compares(input, 17, 61)
  defp solve(10, 2, input), do: AoC.Day10Balance.multiply_outputs(input, [0, 1, 2])

  defp solve(12, 1, input), do: AoC.Day12Leonardo.register_value_after(input, :a)
  defp solve(12, 2, input), do: AoC.Day12Leonardo.register_value_after(input, :a, c: 1)

  defp solve(13, 1, input), do: AoC.Day13Maze.shortest_path(AoC.Day13Maze.Maze.new(String.to_integer(input)), {1, 1}, {31, 39})
  defp solve(13, 2, input), do: AoC.Day13Maze.total_coordinates_reachable(AoC.Day13Maze.Maze.new(String.to_integer(input)), {1, 1}, 50)

  defp solve(14, 1, input), do: AoC.Day14OTP.nth_key_index(input, 64)
  defp solve(14, 2, input), do: AoC.Day14OTP.nth_key_index(input, 64, 2016)

  defp solve(15, 1, input), do: AoC.Day15Timing.earliest_fall_through(input)
  defp solve(15, 2, input), do: AoC.Day15Timing.earliest_fall_through(input, :part_2)

  defp solve(16, 1, input), do: AoC.Day16Dragon.fill(input, 272) |> elem(1)
  defp solve(16, 2, input), do: AoC.Day16Dragon.fill(input, 35651584) |> elem(1)

  defp solve(17, 1, input), do: AoC.Day17TwoSteps.shortest_path(input)
  defp solve(17, 2, input), do: AoC.Day17TwoSteps.longest_path(input)

  defp solve(18, 1, input), do: AoC.Day18Rouge.safe_tiles_count(input, 40)
  defp solve(18, 2, input), do: AoC.Day18Rouge.safe_tiles_count(input, 400_000)

  defp solve(19, 1, input), do: AoC.Day19Elephant.winner(String.to_integer(input), :steal_left)

  defp solve(20, 1, input), do: AoC.Day20Firewall.lowest_allowed(input)
  defp solve(20, 2, input), do: AoC.Day20Firewall.ips_allowed(input, 4294967295)

  defp solve(21, 1, input), do: AoC.Day21Scramble.scramble_string("abcdefgh", input)
  defp solve(21, 2, input), do: AoC.Day21Scramble.unscramble_string("fbgdceah", input)

  defp solve(22, 1, input), do: AoC.Day22Grid.count_viable_pairs(input)

  defp solve(23, 1, input), do: AoC.Day23Safe.safe_value(input, a: 7)
  defp solve(23, 2, input), do: AoC.Day23Safe.safe_value(input, a: 12)

  defp solve(24, 1, input), do: AoC.Day24Spurlunking.fewest_steps(input)

  defp solve(_, _, _input), do: "not implemented!"
end
