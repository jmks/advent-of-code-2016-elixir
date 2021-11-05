defmodule Mix.Tasks.Solve do
  use Mix.Task

  @mf %{
    "01" => {AoC.Day01NoTime, :blocks_away, :first_visited_twice},
    "02" => {AoC.Day02BathroomSecurity, :bathroom_code, :not_implemented}
  }

  @impl Mix.Task
  def run([day]) do
    day = String.pad_leading(day, 2, "0")
    input = File.read!(Path.join([File.cwd!, "data", day]))
    {mod, funa, funb} = Map.fetch!(@mf, day)

    Mix.shell.info("Solution for Day #{day}, part 1: #{inspect apply(mod, funa, [input])}")
    if funb == :not_implemented do
      Mix.shell.info("Part 2 is not implemented")
    else
      Mix.shell.info("Solution for Day #{day}, part 2: #{inspect apply(mod, funb, [input])}")
    end
  end
end
