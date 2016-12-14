
defmodule Day13 do
  require Integer

  def draw_sample() do
    draw_maze(9, 6, 7, 4, 10)
  end

  def draw_puzzle() do
    draw_maze(40, 50, 31, 39, 1352)
  end

  @doc ~s"""

  """
  def navigate_sample() do
    navigate({7, 4}, 10)
  end

  def navigate({goal_x, goal_y}, favorite_number) do

  end

  @doc ~s"""
  iex> Day13.wall_or_open_space(1, 0, 10)
  :wall

  iex> Day13.wall_or_open_space(1, 1, 10)
  :open_space
  """
  def wall_or_open_space(x, y, favorite_number) do
    (x*x + 3*x + 2*x*y + y + y*y + favorite_number)
    |> Integer.to_charlist(2)
    |> Enum.filter(&(&1 == ?1))
    |> Enum.count
    |> wall_or_open_space
  end

  defp wall_or_open_space(bit_count) when Integer.is_even(bit_count), do: :open_space
  defp wall_or_open_space(_), do: :wall

  defp draw_maze(width, height, goal_x, goal_y, favorite_number) do
    IO.write("   ")
    0..width
    |> Enum.each(&(IO.write("#{div(&1,10)}")))
    IO.write("\n   ")
    0..width
    |> Enum.each(&(IO.write("#{rem(&1,10)}")))
    (for y <- 0..height,
         x <- 0..width,
         do: {x, y})
    |> Enum.each(fn {x, y} ->
        if 0 == x do
          IO.write("\n#{y |> Integer.to_string |> String.rjust(2, ?0)} ")
        end
        if (x == goal_x && y == goal_y) do
          IO.write("X")
        else
          wall_or_open_space(x, y, favorite_number)
          |> display
          |> IO.write
        end
      end)
    IO.puts("")
  end

  defp display(:wall), do: "#"
  defp display(:open_space), do: "."

end