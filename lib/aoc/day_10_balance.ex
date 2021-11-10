defmodule AoC.Day10Balance do
  @moduledoc """
  --- Day 10: Balance Bots ---

  You come upon a factory in which many robots are zooming around handing small microchips to each other.

  Upon closer examination, you notice that each bot only proceeds when it has two microchips, and once it does, it gives each one to a different bot or puts it in a marked "output" bin. Sometimes, bots take microchips from "input" bins, too.

  Inspecting one of the microchips, it seems like they each contain a single number; the bots must use some logic to decide what to do with each chip. You access the local control computer and download the bots' instructions (your puzzle input).

  Some of the instructions specify that a specific-valued microchip should be given to a specific bot; the rest of the instructions indicate what a given bot should do with its lower-value or higher-value chip.

  For example, consider the following instructions:

  value 5 goes to bot 2
  bot 2 gives low to bot 1 and high to bot 0
  value 3 goes to bot 1
  bot 1 gives low to output 1 and high to bot 0
  bot 0 gives low to output 2 and high to output 0
  value 2 goes to bot 2

  Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip.
  Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0.
  Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0.
  Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0.
  In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a value-2 microchip, and output bin 2 contains a value-3 microchip. In this configuration, bot number 2 is responsible for comparing value-5 microchips with value-2 microchips.

  Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips?
  """
  defmodule Parser do
    import NimbleParsec

    defparsec(
      :assignment,
      ignore(string("value "))
      |> integer(min: 1)
      |> ignore(string(" goes to bot "))
      |> integer(min: 1)
      |> eos()
    )

    defparsec(
      :give_chip,
      ignore(string("bot "))
      |> integer(min: 1)
      |> ignore(string(" gives low to "))
      |> choice([
        string("bot "),
        string("output ")
      ])
      |> integer(min: 1)
      |> ignore(string(" and high to "))
      |> choice([
        string("bot "),
        string("output ")
      ])
      |> integer(min: 1)
    )
  end

  def parse_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def who_compares(input, low_chip, high_chip) do
    {starting, mappings} =
      input
      |> parse_instructions
      |> Enum.split_with(fn
        {:assign_chip, _, _} -> true
        {:give_chip, _, _, _} -> false
      end)

    bots = Enum.reduce(mappings, %{}, fn {:give_chip, bot, low_dest, high_dest}, acc ->
      Map.put_new(acc, bot, {low_dest, high_dest, []})
    end)

    do_who_compares(starting, [low_chip, high_chip], bots)
  end

  defp do_who_compares([{:assign_chip, _chip, {:output, _output}} | rest], target_chips, bots) do
    do_who_compares(rest, target_chips, bots)
  end

  defp do_who_compares([{:assign_chip, chip, {:bot, bot}} | rest], target_chips, bots) do
   {low_dest, high_dest, chips}  = Map.fetch!(bots, bot)
    new_chips = Enum.sort([chip | chips], :asc)

    cond do
      length(new_chips) == 2 and new_chips == target_chips ->
        bot

      length(new_chips) == 2 ->
        [low_chip, high_chip] = new_chips
        new_assignments = [
          {:assign_chip, low_chip, low_dest},
          {:assign_chip, high_chip, high_dest}
        ]
        new_bots = Map.put(bots, bot, {low_dest, high_dest, []})

        do_who_compares(new_assignments ++ rest, target_chips, new_bots)

      true ->
        new_bots = Map.put(bots, bot, {low_dest, high_dest, new_chips})

        do_who_compares(rest, target_chips, new_bots)
    end
  end

  defp parse_instruction("value " <> _ = instr) do
    {:ok, [value, bot], _, _, _, _} = Parser.assignment(instr)

    {:assign_chip, value, {:bot, bot}}
  end

  defp parse_instruction("bot " <> _ = instr) do
    {:ok, [bot, low_recipient, low_number, high_recipient, high_number], _, _, _, _} = Parser.give_chip(instr)

    {:give_chip, bot, assigned_to(low_recipient, low_number), assigned_to(high_recipient, high_number)}
  end

  defp assigned_to("bot ", number), do: {:bot, number}
  defp assigned_to("output ", number), do: {:output, number}
end
