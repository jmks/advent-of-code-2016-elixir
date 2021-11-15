defmodule AoC.Day12Test do
  use ExUnit.Case

  import AoC.Day12Leonardo
  alias AoC.Day12Leonardo.Assembunny

  @example """
  cpy 41 a
  inc a
  inc a
  dec a
  jnz a 2
  dec a
  """

  describe "Assembunny" do
    test "parse" do
      assert Assembunny.parse(@example).instructions == [
        {:copy, {:value, 41}, {:register, :a}},
        {:inc, {:register, :a}},
        {:inc, {:register, :a}},
        {:dec, {:register, :a}},
        {:jump_if, {:register, :a}, {:value, 2}},
        {:dec, {:register, :a}}
      ]
    end

    test "run" do
      done = Assembunny.parse(@example) |> Assembunny.run()

      assert done.a == 42
    end
  end
end
