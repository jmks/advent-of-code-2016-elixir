defmodule AoC.Day23Test do
  use ExUnit.Case

  import AoC.Day23Safe
  alias AoC.Day23Safe.Assembunny

  @example """
  cpy 2 a
  tgl a
  tgl a
  tgl a
  cpy 1 a
  dec a
  dec a
  """

  test "example" do
    ab =
      @example
      |> Assembunny.parse()
      |> Assembunny.run()

    assert ab.a == 3
  end
end
