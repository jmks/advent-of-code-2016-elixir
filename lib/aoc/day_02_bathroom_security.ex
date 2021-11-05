defmodule AoC.Day02BathroomSecurity do
  @moduledoc """
  --- Day 2: Bathroom Security ---

  You arrive at Easter Bunny Headquarters under cover of darkness. However, you left in such a rush that you forgot to use the bathroom! Fancy office buildings like this one usually have keypad locks on their bathrooms, so you search the front desk for the code.

  "In order to improve security," the document you find says, "bathroom codes will no longer be written down. Instead, please memorize and follow the procedure below to access the bathrooms."

  The document goes on to explain that each button to be pressed can be found by starting on the previous button and moving to adjacent buttons on the keypad: U moves up, D moves down, L moves left, and R moves right. Each line of instructions corresponds to one button, starting at the previous button (or, for the first line, the "5" button); press whatever button you're on at the end of each line. If a move doesn't lead to a button, ignore it.

  You can't hold it much longer, so you decide to figure out the code as you walk to the bathroom. You picture a keypad like this:

  1 2 3
  4 5 6
  7 8 9

  Suppose your instructions are:

  ULL
  RRDDD
  LURDL
  UUUUD

  You start at "5" and move up (to "2"), left (to "1"), and left (you can't, and stay on "1"), so the first button is 1.
  Starting from the previous button ("1"), you move right twice (to "3") and then down three times (stopping at "9" after two moves and ignoring the third), ending up with 9.
  Continuing from "9", you move left, up, right, down, and left, ending with 8.
  Finally, you move up four times (stopping at "2"), then down once, ending with 5.

  So, in this example, the bathroom code is 1985.

  Your puzzle input is the instructions from the document you found at the front desk. What is the bathroom code?

  --- Part Two ---

  You finally arrive at the bathroom (it's a several minute walk from the lobby so visitors can behold the many fancy conference rooms and water coolers on this floor) and go to punch in the code. Much to your bladder's dismay, the keypad is not at all like you imagined it. Instead, you are confronted with the result of hundreds of man-hours of bathroom-keypad-design meetings:

      1
    2 3 4
  5 6 7 8 9
    A B C
      D
  You still start at "5" and stop when you're at an edge, but given the same instructions as above, the outcome is very different:

  You start at "5" and don't move at all (up and left are both edges), ending at 5.
  Continuing from "5", you move right twice and down three times (through "6", "7", "B", "D", "D"), ending at D.
  Then, from "D", you move five more times (through "D", "B", "C", "C", "B"), ending at B.
  Finally, after five more moves, you end at 3.
  So, given the actual keypad layout, the code would be 5DB3.

  Using the same instructions in your puzzle input, what is the correct bathroom code?
  """

  defmodule Keypad do
    @callback move(String.t() | integer, String.t()) :: String.t()
  end

  defmodule StandardKeypad do
    @behaviour Keypad

    @impl Keypad
    def move(1, "D"), do: 4
    def move(1, "R"), do: 2
    def move(2, "L"), do: 1
    def move(2, "R"), do: 3
    def move(2, "D"), do: 5
    def move(3, "L"), do: 2
    def move(3, "D"), do: 6
    def move(4, "U"), do: 1
    def move(4, "R"), do: 5
    def move(4, "D"), do: 7
    def move(5, "U"), do: 2
    def move(5, "D"), do: 8
    def move(5, "L"), do: 4
    def move(5, "R"), do: 6
    def move(6, "U"), do: 3
    def move(6, "L"), do: 5
    def move(6, "D"), do: 9
    def move(7, "U"), do: 4
    def move(7, "R"), do: 8
    def move(8, "U"), do: 5
    def move(8, "L"), do: 7
    def move(8, "R"), do: 9
    def move(9, "L"), do: 8
    def move(9, "U"), do: 6
    def move(key, _), do: key
  end

  defmodule CrazyKeypad do
    @behaviour Keypad

    @impl Keypad
    def move(1, "D"), do: 3
    def move(2, "R"), do: 3
    def move(2, "D"), do: 6
    def move(3, "L"), do: 2
    def move(3, "U"), do: 1
    def move(3, "R"), do: 4
    def move(3, "D"), do: 7
    def move(4, "L"), do: 3
    def move(4, "D"), do: 8
    def move(5, "R"), do: 6
    def move(6, "L"), do: 5
    def move(6, "U"), do: 2
    def move(6, "R"), do: 7
    def move(6, "D"), do: "A"
    def move(7, "L"), do: 6
    def move(7, "U"), do: 3
    def move(7, "R"), do: 8
    def move(7, "D"), do: "B"
    def move(8, "L"), do: 7
    def move(8, "U"), do: 4
    def move(8, "R"), do: 9
    def move(8, "D"), do: "C"
    def move(9, "L"), do: 8
    def move("A", "U"), do: 6
    def move("A", "R"), do: "B"
    def move("B", "L"), do: "A"
    def move("B", "R"), do: "C"
    def move("B", "D"), do: "D"
    def move("B", "U"), do: 7
    def move("C", "U"), do: 8
    def move("C", "L"), do: "B"
    def move("D", "U"), do: "B"
    def move(key, _), do: key
  end

  def bathroom_code(keypad, instructions) do
    do_bathroom_code(5, String.split(instructions, "\n", trim: true), keypad, [])
    |> Enum.join("")
  end

  defp do_bathroom_code(_, [], _keypad, pressed), do: Enum.reverse(pressed)

  defp do_bathroom_code(key, [instructions | rest], keypad, pressed) do
    new_key = press_keys(keypad, key, instructions)

    do_bathroom_code(new_key, rest, keypad, [new_key | pressed])
  end

  defp press_keys(keypad, start, instructions) do
    instructions
    |> String.codepoints()
    |> Enum.reduce(start, &keypad.move(&2, &1))
  end
end
