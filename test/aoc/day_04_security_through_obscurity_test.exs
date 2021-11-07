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

  test "rotate_letter" do
    assert rotate_letter(" ", 1) == "-"
    assert rotate_letter("-", 1) == " "
    assert rotate_letter("a", 1) == "b"
    assert rotate_letter("z", 1) == "a"
    assert rotate_letter("a", 26) == "a"
  end

  test "decrypt_name" do
    assert decrypt_name(%EncryptedRoom{name: "qzmt-zixmtkozy-ivhz", sector_id: 343}) == "very encrypted name"
  end
end
