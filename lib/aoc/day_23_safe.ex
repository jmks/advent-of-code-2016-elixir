defmodule AoC.Day23Safe do
  @moduledoc """
  --- Day 23: Safe Cracking ---
  This is one of the top floors of the nicest tower in EBHQ. The Easter Bunny's private office is here, complete with a safe hidden behind a painting, and who wouldn't hide a star in a safe behind a painting?

  The safe has a digital screen and keypad for code entry. A sticky note attached to the safe has a password hint on it: "eggs". The painting is of a large rabbit coloring some eggs. You see 7.

  When you go to type the code, though, nothing appears on the display; instead, the keypad comes apart in your hands, apparently having been smashed. Behind it is some kind of socket - one that matches a connector in your prototype computer! You pull apart the smashed keypad and extract the logic circuit, plug it into your computer, and plug your computer into the safe.

  Now, you just need to figure out what output the keypad would have sent to the safe. You extract the assembunny code from the logic chip (your puzzle input).
  The code looks like it uses almost the same architecture and instruction set that the monorail computer used! You should be able to use the same assembunny interpreter for this as you did there, but with one new instruction:

  tgl x toggles the instruction x away (pointing at instructions like jnz does: positive means forward; negative means backward):

  For one-argument instructions, inc becomes dec, and all other one-argument instructions become inc.
  For two-argument instructions, jnz becomes cpy, and all other two-instructions become jnz.
  The arguments of a toggled instruction are not affected.
  If an attempt is made to toggle an instruction outside the program, nothing happens.
  If toggling produces an invalid instruction (like cpy 1 2) and an attempt is later made to execute that instruction, skip it instead.
  If tgl toggles itself (for example, if a is 0, tgl a would target itself and become inc a), the resulting instruction is not executed until the next time it is reached.
  For example, given this program:

  cpy 2 a
  tgl a
  tgl a
  tgl a
  cpy 1 a
  dec a
  dec a

  cpy 2 a initializes register a to 2.
  The first tgl a toggles an instruction a (2) away from it, which changes the third tgl a into inc a.
  The second tgl a also modifies an instruction 2 away from it, which changes the cpy 1 a into jnz 1 a.
  The fourth line, which is now inc a, increments a to 3.
  Finally, the fifth line, which is now jnz 1 a, jumps a (3) instructions ahead, skipping the dec a instructions.
  In this example, the final value in register a is 3.

  The rest of the electronics seem to place the keypad entry (the number of eggs, 7) in register a, run the code, and then send the value left in register a to the safe.

  What value should be sent to the safe?
  """
  defmodule Assembunny do
    defstruct [:instructions, :pc, :a, :b, :c, :d]

    def parse(text, init \\ []) do
      instructions =
        text
        |> String.split("\n", trim: true)
        |> Enum.map(&parse_instruction/1)

      %__MODULE__{
        instructions: instructions,
        pc: 0,
        a: Keyword.get(init, :a, 0),
        b: Keyword.get(init, :b, 0),
        c: Keyword.get(init, :c, 0),
        d: Keyword.get(init, :d, 0)
      }
    end

    def run(ab), do: do_run(ab)

    defp parse_instruction("cpy " <> rest) do
      [from, to] = String.split(rest, " ", parts: 2)

      {:copy, value_or_register(from), value_or_register(to)}
    end

    defp parse_instruction("inc " <> reg), do: {:inc, value_or_register(reg)}
    defp parse_instruction("dec " <> reg), do: {:dec, value_or_register(reg)}

    defp parse_instruction("jnz " <> rest) do
      [if_value, dist] = String.split(rest, " ", parts: 2)

      {:jump_if, value_or_register(if_value), value_or_register(dist)}
    end

    defp parse_instruction("tgl " <> rest), do: {:toggle, value_or_register(rest)}

    defp value_or_register("a"), do: {:register, :a}
    defp value_or_register("b"), do: {:register, :b}
    defp value_or_register("c"), do: {:register, :c}
    defp value_or_register("d"), do: {:register, :d}

    defp value_or_register(int) do
      {:value, String.to_integer(int)}
    end

    defp do_run(ab) do
      if ab.pc >= length(ab.instructions) do
        ab
      else
        instruction = Enum.at(ab.instructions, ab.pc)

        # IO.inspect([pc: ab.pc, a: ab.a, b: ab.b, c: ab.c, d: ab.d])
        # IO.inspect(instruction)
        # IO.puts("---")

        run(instruction, ab) |> do_run()
      end
    end

    defp run({:copy, {:value, val}, {:register, reg}}, ab) do
      struct!(ab, [{reg, val}]) |> inc_pc()
    end

    defp run({:copy, {:register, from}, {:register, to}}, ab) do
      struct!(ab, [{to, Map.get(ab, from)}]) |> inc_pc()
    end

    defp run({:inc, {:register, reg}}, ab) do
      struct!(ab, [{reg, Map.get(ab, reg) + 1}]) |> inc_pc()
    end

    defp run({:dec, {:register, reg}}, ab) do
      struct!(ab, [{reg, Map.get(ab, reg) - 1}]) |> inc_pc()
    end

    defp run({:jump_if, value_or_register, value_or_register_shift}, ab) do
      case value(value_or_register, ab) do
        0 -> inc_pc(ab)
        _ -> inc_pc(ab, value(value_or_register_shift, ab))
      end
    end

    defp run({:toggle, {:register, reg}}, ab) do
      index = ab.pc + Map.fetch!(ab, reg)
      instruction = Enum.at(ab.instructions, index)

      toggled =
        case instruction do
          {:inc, arg} ->
            {:dec, arg}

          {_other, arg} ->
            {:inc, arg}

          {:jump_if, arg1, arg2} ->
            {:copy, arg1, arg2}

          {_other, arg1, arg2} ->
            {:jump_if, arg1, arg2}

          nil ->
            nil
        end

      new_instructions =
        if toggled do
          List.replace_at(ab.instructions, index, toggled)
        else
          ab.instructions
        end

      struct!(ab, instructions: new_instructions) |> inc_pc()
    end

    defp run(_skipped_bad_instruction, ab) do
      inc_pc(ab)
    end

    defp value({:value, val}, _ab), do: val
    defp value({:register, reg}, ab), do: Map.fetch!(ab, reg)

    defp inc_pc(ab, by \\ 1) do
      struct!(ab, pc: ab.pc + by)
    end
  end

  def safe_value(input, starting_registers \\ []) do
    ab =
      input
      |> Assembunny.parse(starting_registers)
      |> Assembunny.run()

    ab.a
  end
end
