defmodule Mix.Tasks.Solve do
  use Mix.Task

  @impl Mix.Task
  def run([day]) do
    day = String.pad_leading(day, 2, "0")
    input = File.read!(Path.join([File.cwd!, "data", day]))

    Mix.shell.info("Solution for Day #{day}, part 1: #{inspect solve(day, 1, input)}")
    Mix.shell.info("Solution for Day #{day}, part 2: #{inspect solve(day, 2, input)}")
  end

  defp solve(day, part, input)

  defp solve("01", 1, input), do: AoC.Day01NoTime.blocks_away(input)
  defp solve("01", 2, input), do: AoC.Day01NoTime.first_visited_twice(input)

  defp solve("02", 1, input), do: AoC.Day02BathroomSecurity.bathroom_code(AoC.Day02BathroomSecurity.StandardKeypad, input)
  defp solve("02", 2, input), do: AoC.Day02BathroomSecurity.bathroom_code(AoC.Day02BathroomSecurity.CrazyKeypad, input)

  defp solve("03", 1, input), do: AoC.Day03SquareWithThreeSides.possible_triangles(input)
  defp solve("03", 2, input), do: AoC.Day03SquareWithThreeSides.possible_vertical_triangles(input)

  defp solve("04", 1, input), do: AoC.Day04SecurityThroughObscurity.sector_sum_of_valid_rooms(input)

  defp solve(_, _, _input), do: "not implemented!"
end
