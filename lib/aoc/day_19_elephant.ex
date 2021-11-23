defmodule AoC.Day19Elephant do
  @moduledoc """
  --- Day 19: An Elephant Named Joseph ---

  The Elves contact you over a highly secure emergency channel. Back at the North Pole, the Elves are busy misunderstanding White Elephant parties.

  Each Elf brings a present. They all sit in a circle, numbered starting with position 1. Then, starting with the first Elf, they take turns stealing all the presents from the Elf to their left. An Elf with no presents is removed from the circle and does not take turns.

  For example, with five Elves (numbered 1 to 5):

    1
  5   2
   4 3

  Elf 1 takes Elf 2's present.
  Elf 2 has no presents and is skipped.
  Elf 3 takes Elf 4's present.
  Elf 4 has no presents and is also skipped.
  Elf 5 takes Elf 1's two presents.

  Neither Elf 1 nor Elf 2 have any presents, so both are skipped.

  Elf 3 takes Elf 5's three presents.

  So, with five Elves, the Elf that sits starting in position 3 gets all the presents.

  With the number of Elves given in your puzzle input, which Elf gets all the presents?

  --- Part Two ---

  Realizing the folly of their present-exchange rules, the Elves agree to instead steal presents from the Elf directly across the circle. If two Elves are across the circle, the one on the left (from the perspective of the stealer) is stolen from. The other rules remain unchanged: Elves with no presents are removed from the circle entirely, and the other elves move in slightly to keep the circle evenly spaced.

  For example, with five Elves (again numbered 1 to 5):

  The Elves sit in a circle; Elf 1 goes first:
    1
  5   2
   4 3
  Elves 3 and 4 are across the circle; Elf 3's present is stolen, being the one to the left. Elf 3 leaves the circle, and the rest of the Elves move in:
    1           1
  5   2  -->  5   2
   4 -          4
  Elf 2 steals from the Elf directly across the circle, Elf 5:
  1           1
  -   2  -->     2
  4           4
  Next is Elf 4 who, choosing between Elves 1 and 2, steals from Elf 1:
  -          2
  2  -->
  4          4
  Finally, Elf 2 steals from Elf 4:
  2
  -->  2
  -
  So, with five Elves, the Elf that sits starting in position 2 gets all the presents.

  With the number of Elves given in your puzzle input, which Elf now gets all the presents?
  """
  def winner_stealing_from_the_left(1), do: 1
  def winner_stealing_from_the_left(2), do: 1

  def winner_stealing_from_the_left(total_elves) do
    # The first round always wipes out the even numbers
    starting = for i <- 1..total_elves, not even?(i) do
      {i, 2}
    end
    # If there's an even number, all evens are gone;
    # but if odd, the last number steals from 1
    starting = if even?(total_elves) do
      starting
    else
      tl(starting)
    end

    do_winner(starting, [])
  end

  def do_winner([{elf, _count}], []), do: elf
  def do_winner([], [{elf, _count}]), do: elf

  def do_winner([], acc) do
    do_winner(Enum.reverse(acc), [])
  end

  def do_winner([{elf, presents}], acc) do
    new_elves = Enum.reverse(acc)

    do_winner([{elf, presents} | new_elves], [])
  end

  def do_winner([{elf, presents} | elves], acc) do
    index = Enum.find_index(elves, fn {_, count} -> count > 0 end)
    new_elves = List.delete_at(elves, index)

    do_winner(new_elves, [{elf, presents} | acc])
  end

  defp even?(number) do
    rem(number, 2) == 0
  end
end
