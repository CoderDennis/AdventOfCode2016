defmodule Day09_2 do

  def puzzle_answer() do
    File.read!("input.txt")
    |> decompressed_length
  end

  @doc ~s"""
  iex> Day09_2.decompressed_length("(3x3)XYZ")
  9

  iex> Day09_2.decompressed_length("X(8x2)(3x3)ABCY")
  20

  iex> Day09_2.decompressed_length("(27x12)(20x12)(13x14)(7x10)(1x12)A")
  241920

  iex> Day09_2.decompressed_length("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
  445
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
    data_length = rest
      |> Enum.drop(String.length(marker) + 1)
      |> Enum.take(count)
      |> decompressed_length(0)
    decompressed_length(
      rest |> Enum.drop(String.length(marker) + count + 1),
      data_length * repeat + length)
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