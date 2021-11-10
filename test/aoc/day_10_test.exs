defmodule AoC.Day10Test do
  use ExUnit.Case

  import AoC.Day10Balance

  @example_input """
  value 5 goes to bot 2
  bot 2 gives low to bot 1 and high to bot 0
  value 3 goes to bot 1
  bot 1 gives low to output 1 and high to bot 0
  bot 0 gives low to output 2 and high to output 0
  value 2 goes to bot 2
  """

  describe "parse_instructions" do
    test "chip assignments" do
      assert parse_instructions("""
      value 5 goes to bot 2
      value 3 goes to bot 4
      """) == [
        {:assign_chip, 5, {:bot, 2}},
        {:assign_chip, 3, {:bot, 4}}
      ]
    end

    test "give_chip" do
      assert parse_instructions("bot 1 gives low to bot 3 and high to bot 7") == [
        {:give_chip, 1, {:bot, 3}, {:bot, 7}}
      ]

      assert parse_instructions("bot 1 gives low to output 3 and high to bot 7") == [
        {:give_chip, 1, {:output, 3}, {:bot, 7}}
      ]

      assert parse_instructions("bot 1 gives low to output 3 and high to output 7") == [
        {:give_chip, 1, {:output, 3}, {:output, 7}}
      ]
    end
  end

  test "example" do
    assert parse_instructions(@example_input) == [
      {:assign_chip, 5, {:bot, 2}},
      {:give_chip, 2, {:bot, 1}, {:bot, 0}},
      {:assign_chip, 3, {:bot, 1}},
      {:give_chip, 1, {:output, 1}, {:bot, 0}},
      {:give_chip, 0, {:output, 2}, {:output, 0}},
      {:assign_chip, 2, {:bot, 2}}
    ]
  end

  test "who_compares" do
    assert who_compares(@example_input, 2, 5) == 2
  end
end
