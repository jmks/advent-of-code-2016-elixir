defmodule AoC.Day04SecurityThroughObscurity do
  @moduledoc """
  --- Day 4: Security Through Obscurity ---
  Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.

  Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.

  A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:

  aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
  a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
  not-a-real-room-404[oarel] is a real room.
  totally-real-room-200[decoy] is not.

  Of the real rooms from the list above, the sum of their sector IDs is 1514.

  What is the sum of the sector IDs of the real rooms?

  --- Part Two ---
  With all the decoy data out of the way, it's time to decrypt this list and get moving.

  The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.

  To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.

  For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.

  What is the sector ID of the room where North Pole objects are stored?
  """
  defmodule EncryptedRoom do
    defstruct [:name, :sector_id, :checksum]

    def new(encrypted) do
      parts = String.split(encrypted, "-", trim: true)

      name = parts |> Enum.take(length(parts) - 1) |> Enum.join("-")
      [sector_id, cs] = parts |> List.last() |> String.split("[", parts: 2)

      %__MODULE__{
        name: name,
        sector_id: String.to_integer(sector_id),
        checksum: String.trim_trailing(cs, "]")
      }
    end
  end

  def valid_checksum?(encrypted_room) when is_binary(encrypted_room) do
    encrypted_room
    |> EncryptedRoom.new()
    |> valid_checksum?
  end

  def valid_checksum?(%EncryptedRoom{} = room) do
    computed_checksum =
      room.name
      |> String.graphemes()
      |> Enum.reject(&(&1 == "-"))
      |> Enum.frequencies()
      |> Enum.into([])
      |> Enum.sort_by(fn {letter, freq} -> {-freq, letter} end, :asc)
      |> Enum.take(5)
      |> Enum.map(fn {letter, _freq} -> letter end)
      |> Enum.join("")

    computed_checksum == room.checksum
  end

  def sector_sum_of_valid_rooms(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&EncryptedRoom.new/1)
    |> Enum.filter(&valid_checksum?/1)
    |> Enum.map(& &1.sector_id)
    |> Enum.sum()
  end

  def rotate_letter("-", times) when rem(times, 2) == 0, do: "-"
  def rotate_letter("-", _), do: " "

  def rotate_letter(" ", times) when rem(times, 2) == 0, do: " "
  def rotate_letter(" ", _), do: "-"

  def rotate_letter(letter, times) do
    letters = String.graphemes("abcdefghijklmnopqrstuvwxyz")
    index = Enum.find_index(letters, &(&1 == letter))
    shift = rem(times, 26)

    Enum.at(letters, rem(index + shift, 26))
  end

  def decrypt_name(%EncryptedRoom{} = room) do
    room.name
    |> String.graphemes()
    |> Enum.map(&rotate_letter(&1, room.sector_id))
    |> Enum.join("")
  end

  def find_north_pole(input) do
    room =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&EncryptedRoom.new/1)
      |> Enum.filter(&valid_checksum?/1)
      |> Enum.find(fn room -> decrypt_name(room) == "northpole-object-storage" end)

    room.sector_id
  end
end
