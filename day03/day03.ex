defmodule Day03 do

  def count_valid_triangles() do
    File.stream!("input.txt")
    |> Stream.map(fn s -> String.split(s, " ") |> Enum.reject(&(&1 == "")) end)
    |> Stream.filter(&valid_triangle?/1)
    |> Enum.count
  end

  def count_valid_triangles_by_columns() do
    File.stream!("input.txt")
    |> Stream.map(fn s -> String.split(s, " ") |> Enum.reject(&(&1 == "")) end)
    |> read_triangles_by_columns
    |> Enum.filter(&valid_triangle?/1)
    |> Enum.count
  end

  @doc ~s"""
  # Examples

    iex> Day03.read_triangles_by_columns([["101", "301", "501"], ["102", "302", "502"], ["103", "303", "503"], ["201", "401", "601"], ["202", "402", "602"], ["203", "403", "603"]])
    [["101", "102", "103"],["201", "202", "203"],["301", "302", "303"],["401", "402", "403"],["501", "502", "503"],["601", "602", "603"]]

  """
  def read_triangles_by_columns(rows) do
    rows
    |> transpose
    |> List.flatten
    |> Enum.chunk(3)
  end

  defp transpose([[]|_]), do: []
  defp transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
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