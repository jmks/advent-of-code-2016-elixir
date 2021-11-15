defmodule AoC.Day12Leonardo do
  @moduledoc """
  --- Day 12: Leonardo's Monorail ---

  You finally reach the top floor of this building: a garden with a slanted glass ceiling. Looks like there are no more stars to be had.

  While sitting on a nearby bench amidst some tiger lilies, you manage to decrypt some of the files you extracted from the servers downstairs.

  According to these documents, Easter Bunny HQ isn't just this building - it's a collection of buildings in the nearby area. They're all connected by a local monorail, and there's another building not far from here! Unfortunately, being night, the monorail is currently not operating.

  You remotely connect to the monorail control systems and discover that the boot sequence expects a password. The password-checking logic (your puzzle input) is easy to extract, but the code it uses is strange: it's assembunny code designed for the new computer you just assembled. You'll have to execute the code and get the password.

  The assembunny code you've extracted operates on four registers (a, b, c, and d) that start at 0 and can hold any integer. However, it seems to make use of only a few instructions:

  cpy x y copies x (either an integer or the value of a register) into register y.
  inc x increases the value of register x by one.
  dec x decreases the value of register x by one.
  jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.
  The jnz instruction moves relative to itself: an offset of -1 would continue at the previous instruction, while an offset of 2 would skip over the next instruction.

  For example:

  cpy 41 a
  inc a
  inc a
  dec a
  jnz a 2
  dec a

  The above code would set register a to 41, increase its value by 2, decrease its value by 1, and then skip the last dec a (because a is not zero, so the jnz a 2 skips it), leaving register a at 42. When you move past the last instruction, the program halts.

  After executing the assembunny code in your puzzle input, what value is left in register a?
  """
  defmodule Assembunny do
    defstruct [:instructions, :pc, :a, :b, :c, :d]

    def parse(text) do
      instructions =
        text
        |> String.split("\n", trim: true)
        |> Enum.map(&parse_instruction/1)

      %__MODULE__{instructions: instructions, pc: 0, a: 0, b: 0, c: 0, d: 0}
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

    defp run({:jump_if, {:value, val}, {:value, pc_shift}}, ab) do
      case val do
        0 -> inc_pc(ab)
        _ -> inc_pc(ab, pc_shift)
      end
    end

    defp run({:jump_if, {:register, reg}, {:value, pc_shift}}, ab) do
      case Map.get(ab, reg) do
        0 -> inc_pc(ab)
        _ -> inc_pc(ab, pc_shift)
      end
    end

    defp inc_pc(ab, by \\ 1) do
      struct!(ab, pc: ab.pc + by)
    end
  end

  def register_value_after(input, register) do
    input
    |> Assembunny.parse
    |> Assembunny.run
    |> Map.get(register)
  end
end
