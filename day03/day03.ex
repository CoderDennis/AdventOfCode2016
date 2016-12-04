defmodule Day03 do

  def count_valid_triangles() do
    File.stream!("input.txt")
    |> Stream.map(fn s -> String.split(s, " ") |> Enum.reject(&(&1 == "")) end)
    |> Stream.filter(&valid_triangle?/1)
    |> Enum.count
  end

  @doc ~s"""
  # Examples

    iex> Day03.valid_triangle?(["25 ", "10", "5 "])
    false

    iex> Day03.valid_triangle?(["3", "3", "5"])
    true
  """
  def valid_triangle?(sides) do
    sides
    |> Enum.map(&(String.strip(&1) |> String.to_integer))
    |> Enum.sort
    |> two_sides_greater_than_third
  end

  defp two_sides_greater_than_third(sorted_sides) do
    two_sides = sorted_sides
      |> Enum.take(2)
      |> Enum.sum
    third_side = sorted_sides
      |> List.last
    two_sides > third_side
  end
end