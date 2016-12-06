defmodule Day05_2 do

  def puzzle_answer() do
    get_password("abbhdwsy")
  end

  @doc ~s"""
  # Examples

    iex> Day05_2.get_password("abc")
    "05ace8e3"
  """
  def get_password(doorId) do
    Stream.iterate(1, &(&1+1))
    |> Stream.map(&(get_hash(doorId, &1)))
    |> Stream.filter(&is_password_component?/1)
    |> Stream.map(&get_password_char/1)
    |> Stream.filter(&ok_filter/1)
    |> Stream.transform([], fn {_, position, char}, positions ->
        if Enum.count(positions) == 8 do
          {:halt, positions}
        else
          if position in positions do
            {[], positions}
          else
            {[{position, char}], [position | positions]}
          end
        end
      end)
    # |> Enum.each(&IO.inspect/1)
    |> Enum.sort_by(&(elem(&1, 0)))
    |> Enum.map(&(elem(&1, 1)))
    |> List.to_string()
    |> String.downcase()
  end

  defp get_hash(doorId, number) do
    :crypto.hash(:md5, "#{doorId}#{number}")
    |> Base.encode16
  end

  defp is_password_component?(hash) do
    hash
    |> String.starts_with?("00000")
  end

  @valid_positions ["0", "1", "2", "3", "4", "5", "6", "7"]

  @doc ~s"""
    iex> Day05_2.get_password_char("0000015")
    {:ok, 1, "5"}

    iex> Day05_2.get_password_char("0000085")
    {:invalid}

    iex> Day05_2.get_password_char("00000F5")
    {:invalid}
  """
  def get_password_char(hash) do
    position = String.at(hash, 5)
    if position in @valid_positions do
      {:ok, String.to_integer(position), String.at(hash, 6)}
    else
      {:invalid}
    end
  end

  defp ok_filter({:ok, _, _}), do: true
  defp ok_filter(_), do: false

end
