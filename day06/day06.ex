defmodule Day06 do

  def puzzle_answer() do
    recover_message("input.txt")
  end

  @doc ~s"""
  iex> Day06.puzzle_test
  "easter"
  """
  def puzzle_test() do
    recover_message("test.txt")
  end

  def recover_message(filename) do
    File.stream!(filename)
    |> Stream.map(&(&1 |> String.strip |> String.codepoints))
    |> transpose
    |> Enum.map(&most_frequent_letter/1)
    |> List.to_string
  end

  defp most_frequent_letter(list) do
    list
    |> Enum.reduce(%{}, fn (l, map) -> Map.update(map, l, 1, &(&1 + 1)) end)
    |> Enum.max_by(fn {_, count} -> count end)
    |> elem(0)
  end

  defp transpose([[]|_]), do: []
  defp transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

end