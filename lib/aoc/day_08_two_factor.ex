defmodule AoC.Day08TwoFactor do
  @moduledoc """
  --- Day 8: Two-Factor Authentication ---
  You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.

  To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.

  Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.

  The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:

  rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
  rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
  rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.
  For example, here is a simple sequence on a smaller screen:

  rect 3x2 creates a small rectangle in the top-left corner:
  ###....
  ###....
  .......

  rotate column x=1 by 1 rotates the second column down by one pixel:
  #.#....
  ###....
  .#.....

  rotate row y=0 by 4 rotates the top row right by four pixels:
  ....#.#
  ###....
  .#.....

  rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:
  .#..#.#
  #.#....
  .#.....

  As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.

  There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?
  """
  defmodule Screen do
    defstruct [:width, :height, :pixels, :last_instruction]

    def new(width \\ 50, height \\ 6) do
      pixels = for w <- 1..width, h <- 1..height, into: %{} do {{w, h}, false} end

      %__MODULE__{
        width: width,
        height: height,
        pixels: pixels,
        last_instruction: nil
      }
    end

    def turn_on(screen, pixel) do
      new_pixels = Map.put(screen.pixels, pixel, true)

      struct!(screen, pixels: new_pixels)
    end

    def on?(screen, pixel) do
      Map.fetch!(screen.pixels, pixel)
    end

    def on_count(screen) do
      Enum.count(screen.pixels, fn  {_coord, state} -> state end)
    end

    def instruction(screen, instruction)

    def instruction(screen, {:rect, columns, rows} = instr) do
      changed_pixels = for col <- 1..columns, row <- 1..rows, do: {{col, row}, true}

      struct!(screen, pixels: replace_pixels(screen.pixels, changed_pixels), last_instruction: instr)
    end

    def instruction(screen, {:rotate_row, row, spaces} = instr) do
      row = row + 1
      changed_pixels = for col <- 1..screen.width do
        old_coord = {col, row}
        new_col = case rem(col + spaces, screen.width) do
                    0 -> screen.width
                    i -> i
                  end
        new_coord = {new_col, row}

        {new_coord, Map.fetch!(screen.pixels, old_coord)}
      end

       struct!(screen, pixels: replace_pixels(screen.pixels, changed_pixels), last_instruction: instr)
    end

    def instruction(screen, {:rotate_col, col, spaces} = instr) do
      col = col + 1
      changed_pixels = for row <- 1..screen.height do
        old_coord = {col, row}
        new_row = case rem(row + spaces, screen.height) do
                    0 -> screen.height
                    i -> i
                  end
        new_coord = {col, new_row}

        {new_coord, Map.fetch!(screen.pixels, old_coord)}
      end

      struct!(screen, pixels: replace_pixels(screen.pixels, changed_pixels), last_instruction: instr)
    end

    defp replace_pixels(pixels, updated_pixels) do
      Enum.reduce(updated_pixels, pixels, fn {coord, state}, map ->
        Map.replace(map, coord, state)
      end)
    end
  end

  defimpl Inspect, for: Screen do
    def inspect(screen, _opts) do
      rows = for row <- 1..screen.height do
        for col <- 1..screen.width do
          if Screen.on?(screen, {col, row}), do: "#", else: "."
        end
      end
      instr = if screen.last_instruction do
        "(after #{inspect screen.last_instruction})"
      else
        nil
      end

      """
      #{screen.height}X#{screen.width} #{instr}
      #{Enum.join(rows, "\n")}
      """
    end
  end

  def pixels_on(input) do
    instructions = parse_instructions(input)
    screen = Enum.reduce(instructions, Screen.new, &(Screen.instruction(&2, &1)))

    Screen.on_count(screen)
  end

  def parse_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction("rect " <> size) do
    [left, right] = String.split(size, "x")

    {:rect, String.to_integer(left), String.to_integer(right)}
  end

  defp parse_instruction("rotate row " <> row) do
    parse_rotation(:rotate_row, row)
  end

  defp parse_instruction("rotate column " <> row) do
    parse_rotation(:rotate_col, row)
  end

  defp parse_rotation(type, string) do
    [_, by] = String.split(string, "=")
    [col, dist] = String.split(by, " by ")

    {type, String.to_integer(col), String.to_integer(dist)}
  end
end
