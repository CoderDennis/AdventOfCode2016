defmodule Day04 do

  def sum_of_sector_ids_of_real_rooms() do
    real_rooms()
    |> Stream.map(fn {id, _} -> id end)
    |> Enum.sum
  end

  def decrypt_room_names() do
    real_rooms()
    |> Stream.map(fn {sector_id, encrypted} -> {sector_id, decrypt_name(encrypted, sector_id)} end)
  end

  def real_rooms() do
    File.stream!("input.txt")
    |> Stream.map(&validate_room/1)
    |> Stream.filter(fn
        {:real, _, _} -> true
        {:decoy, _, _} -> false
      end)
    |> Stream.map(fn {_, id, name} -> {id, name} end)
  end

  @doc ~s"""
  # Examples

    iex> Day04.decrypt_name("qzmt-zixmtkozy-ivhz", 343)
    "very encrypted name"
  """
  def decrypt_name(encrypted, sector_id) do
    decrypt_name(encrypted |> String.codepoints, sector_id, [])
  end

  def decrypt_name([], _, decrypted) do
    decrypted
    |> Enum.reverse
    |> List.to_string
  end
  def decrypt_name([a|rest], rotate_count, decrypted) do
    decrypt_name(rest, rotate_count, [shift_letter(a, rotate_count)|decrypted])
  end

  @letters "abcdefghijklmnopqrstuvwxyz" |> String.codepoints

  defp shift_letter("-", _), do: " "
  defp shift_letter(l, rotate_count) do
    Enum.at(@letters, rem(Enum.find_index(@letters, &(&1 == l)) + rotate_count, 26))
  end

  @doc ~s"""
  Validates checksum for room data.

  Returns tuple with either :real or :decoy followed by sector ID

  # Examples

    iex> Day04.validate_room("aaaaa-bbb-z-y-x-123[abxyz]")
    {:real, 123, "aaaaa-bbb-z-y-x"}

    iex> Day04.validate_room("a-b-c-d-e-f-g-h-987[abcde]")
    {:real, 987, "a-b-c-d-e-f-g-h"}

    iex> Day04.validate_room("not-a-real-room-404[oarel]")
    {:real, 404, "not-a-real-room"}

    iex> Day04.validate_room("totally-real-room-200[decoy]")
    {:decoy, 200, "totally-real-room"}

  """
  def validate_room(room) do
    {:ok, counts, name, {sector_id, checksum}} =
      room
      |> String.codepoints
      |> parse_name(%{}, [])
    common_letters =
      counts
      |> Enum.sort(fn
          {l1, c}, {l2, c} -> l1 < l2
          {_, c1}, {_, c2} -> c1 > c2
        end)
      |> Enum.take(5)
      |> Enum.map(fn {l, _} -> l end)
      |> List.to_string
    if common_letters == checksum do
      {:real, sector_id, name}
    else
      {:decoy, sector_id, name}
    end
  end

  @digits ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

  def parse_name([a|_] = id_and_checksum, letter_count, [_|name]) when a in @digits do
    {:ok, letter_count, name |> Enum.reverse |> List.to_string, parse_id_and_checksum(id_and_checksum, [])}
  end
  def parse_name(["-"|rest], letter_count, name), do: parse_name(rest, letter_count, ["-"|name])
  def parse_name([a|rest], letter_count, name) do
    parse_name(rest, letter_count |> Map.update(a, 1, &(&1 + 1)), [a|name])
  end

  @doc ~s"""
  # Examples

    iex> "123[abxyz]" |> String.codepoints |> Day04.parse_id_and_checksum([])
    {123, "abxyz"}

  """
  def parse_id_and_checksum([a|rest], id) when a in @digits do
    parse_id_and_checksum(rest, [a|id])
  end
  def parse_id_and_checksum(checksum, id) do
    checksum = checksum
    |> Enum.drop(1)
    |> Enum.take_while(&(&1 != "]"))
    |> List.to_string
    {id |> Enum.reverse |> List.to_string |> String.to_integer, checksum}
  end

end
