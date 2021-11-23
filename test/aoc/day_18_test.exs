defmodule AoC.Day18Test do
  use ExUnit.Case

  import AoC.Day18Rouge

  test "tile_type" do
    assert tile_type({:trap, :trap, :safe}) == :trap
    assert tile_type({:safe, :trap, :trap}) == :trap
    assert tile_type({:trap, :safe, :safe}) == :trap
    assert tile_type({:safe, :safe, :trap}) == :trap

    assert tile_type({:trap, :trap, :trap}) == :safe
    assert tile_type({:safe, :safe, :safe}) == :safe
    assert tile_type({:trap, :safe, :trap}) == :safe
    assert tile_type({:safe, :trap, :safe}) == :safe
  end

  test "next_row" do
    assert next_row("..^^." |> decode_row()) == decode_row(".^^^^")
    assert next_row(".^^^^" |> decode_row()) == decode_row("^^..^")
  end

  test "safe_tiles_count" do
    assert safe_tiles_count("..^^.", 3) == 6
    assert safe_tiles_count(".^^.^.^^^^", 10) == 38
  end
end
