defmodule Day05 do

  def puzzle_answer() do
    get_password("abbhdwsy")
  end

  @doc ~s"""
  # Examples

    iex> Day05.get_password("abc")
    "18f47a30"
  """
  def get_password(doorId) do
    Stream.iterate(1, &(&1+1))
    |> Stream.map(&(get_hash(doorId, &1)))
    |> Stream.filter(&is_password_component?/1)
    |> Stream.take(8)
    |> Enum.map(&get_password_char/1)
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

  defp get_password_char("00000" <> v), do: String.first(v)
end