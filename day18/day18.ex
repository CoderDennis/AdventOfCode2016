defmodule Day18 do

  def puzzle_answer() do
    ".^^^.^.^^^^^..^^^..^..^..^^..^.^.^.^^.^^....^.^...^.^^.^^.^^..^^..^.^..^^^.^^...^...^^....^^.^^^^^^^"
    |> count_safe_tiles_in_rows(400000)
  end

  @doc """
  iex> Day18.count_safe_tiles_in_rows(".^^.^.^^^^", 10)
  38
  """
  def count_safe_tiles_in_rows(input, rows) do
    input
    |> String.codepoints
    |> Stream.iterate(&next_row/1)
    |> Stream.take(rows)
    |> Enum.reduce(0, &count_safe_tiles/2)
  end

  def count_safe_tiles(row, total) do
    Enum.count(row, &(&1 == ".")) + total
  end

  @doc """
  iex> Day18.next_row("..^^." |> String.codepoints) |> List.to_string
  ".^^^^"

  iex> Day18.next_row(".^^^^" |> String.codepoints) |> List.to_string
  "^^..^"
  """
  def next_row(row) do
    ["." | row]
    |> Enum.chunk(3, 1, ["."])
    |> Enum.map(&new_tile/1)
  end

  def new_tile(["^", "^", "."]), do: "^"
  def new_tile([".", "^", "^"]), do: "^"
  def new_tile(["^", ".", "."]), do: "^"
  def new_tile([".", ".", "^"]), do: "^"
  def new_tile(_), do: "."

end