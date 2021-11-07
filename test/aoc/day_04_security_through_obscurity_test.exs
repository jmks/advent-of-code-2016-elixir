defmodule AoC.Day04SecurityThroughObscurityTest do
  use ExUnit.Case

  import AoC.Day04SecurityThroughObscurity
  alias AoC.Day04SecurityThroughObscurity.EncryptedRoom

  describe "EncryptedRoom" do
    test "new" do
      room = EncryptedRoom.new("aaaaa-bbb-z-y-x-123[abxyz]")

      assert room.name == "aaaaa-bbb-z-y-x"
      assert room.sector_id == 123
      assert room.checksum == "abxyz"
    end
  end

  test "valid_checksum?" do
    assert valid_checksum?("aaaaa-bbb-z-y-x-123[abxyz]")
    assert valid_checksum?("a-b-c-d-e-f-g-h-987[abcde]")
    assert valid_checksum?("not-a-real-room-404[oarel]")
    refute valid_checksum?("totally-real-room-200[decoy]")
  end

  test "sector_sum_of_valid_rooms" do
    assert sector_sum_of_valid_rooms("""
    aaaaa-bbb-z-y-x-123[abxyz]
    a-b-c-d-e-f-g-h-987[abcde]
    not-a-real-room-404[oarel]
    totally-real-room-200[decoy]
    """) == 1514
  end
end
