defmodule Day04 do

  def sum_of_sector_ids_of_real_rooms() do
    File.stream!("input.txt")
    |> Stream.map(&validate_room/1)
    |> Stream.filter(fn
        {:real, _} -> true
        {:decoy, _} -> false
      end)
    |> Stream.map(fn {_, id} -> id end)
    |> Enum.sum
  end

  @doc ~s"""
  Validates checksum for room data.

  Returns tuple with either :real or :decoy followed by sector ID

  # Examples

    iex> Day04.validate_room("aaaaa-bbb-z-y-x-123[abxyz]")
    {:real, 123}

    iex> Day04.validate_room("a-b-c-d-e-f-g-h-987[abcde]")
    {:real, 987}

    iex> Day04.validate_room("not-a-real-room-404[oarel]")
    {:real, 404}

    iex> Day04.validate_room("totally-real-room-200[decoy]")
    {:decoy, 200}

  """
  def validate_room(room) do
    {:ok, counts, {sector_id, checksum}} = room
    |> String.codepoints
    |> parse_name(%{})
    common_letters = counts
    |> Enum.sort(fn
        {l1, c}, {l2, c} -> l1 < l2
        {_, c1}, {_, c2} -> c1 > c2
      end)
    |> Enum.take(5)
    |> Enum.map(fn {l, _} -> l end)
    |> List.to_string
    if common_letters == checksum do
      {:real, sector_id}
    else
      {:decoy, sector_id}
    end
  end

  @digits ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

  def parse_name(["-"|rest], letter_count), do: parse_name(rest, letter_count)
  def parse_name([a|_] = name, letter_count) when a in @digits do
    {:ok, letter_count, parse_id_and_checksum(name, [])}
  end
  def parse_name([a|rest], letter_count) do
    parse_name(rest, letter_count |> Map.update(a, 1, &(&1 + 1)))
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

%{"a" => 2, "e" => 1, "l" => 1, "m" => 1, "n" => 1, "o" => 3, "r" => 2, "t" => 1}