defmodule Day09 do

  def puzzle_answer() do
    File.read!("input.txt")
    |> decompressed_length
  end

  @doc ~s"""
  iex> Day09.decompressed_length("ADVENT")
  6

  iex> Day09.decompressed_length("A(1x5)BC")
  7

  iex> Day09.decompressed_length("(3x3)XYZ")
  9

  iex> Day09.decompressed_length("A(2x2)BCD(2x2)EFG")
  11

  iex> Day09.decompressed_length("(6x1)(1x3)A")
  6

  iex> Day09.decompressed_length("X(8x2)(3x3)ABCY")
  18
  """
  def decompressed_length(string) do
    string
    |> String.codepoints
    |> decompressed_length(0)
  end

  def decompressed_length([], length), do: length
  def decompressed_length(["(" | rest], length) do
    marker = rest |> Enum.take_while(&(&1 != ")")) |> List.to_string
    {count, repeat} = parse_marker(marker)
    decompressed_length(
      rest |> Enum.drop(String.length(marker) + count + 1),
      count * repeat + length)
  end
  def decompressed_length(["\n" | rest], length), do: decompressed_length(rest, length)
  def decompressed_length([_char | rest], length), do: decompressed_length(rest, length + 1)

  defp parse_marker(marker) do
    Regex.run(~r/(\d+)x(\d+)/, marker)
    |> regex_results_to_tuple
  end

  defp regex_results_to_tuple(re) do
    re
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

end