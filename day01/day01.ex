defmodule Day01 do
  @doc ~s"""

  # Examples

    iex> Day01.blocks_to_easter_bunny_hq("R2, L3")
    5

    iex> Day01.blocks_to_easter_bunny_hq("R2, R2, R2")
    2

    iex> Day01.blocks_to_easter_bunny_hq("R5, L5, R5, R3")
    12

  """
  def blocks_to_easter_bunny_hq(instructions) do
    instructions
    |> String.split(", ")
    |> Enum.reduce({{0,0}, :north}, &follow_instruction/2)
    |> absolute_distance
  end

  defp follow_instruction("R" <> distance, {position, direction}) do
    direction = turn_r(direction)
    do_move(distance, {position, direction})
  end
  defp follow_instruction("L" <> distance, {position, direction}) do
    direction = turn_l(direction)
    do_move(distance, {position, direction})
  end

  defp do_move(distance, {position, direction}) do
    distance = String.strip(distance)
    {move(position, String.to_integer(distance), direction), direction}
  end

  defp turn_r(:north), do: :east
  defp turn_r(:east ), do: :south
  defp turn_r(:south), do: :west
  defp turn_r(:west ), do: :north

  defp turn_l(:north), do: :west
  defp turn_l(:west ), do: :south
  defp turn_l(:south), do: :east
  defp turn_l(:east ), do: :north

  defp move({x, y}, distance, :north), do: {x+distance, y         }
  defp move({x, y}, distance, :east ), do: {x,          y+distance}
  defp move({x, y}, distance, :south), do: {x-distance, y         }
  defp move({x, y}, distance, :west ), do: {x,          y-distance}

  defp absolute_distance({{x, y}, _}), do: abs(x) + abs(y)
end

# iex> File.read!("input.txt")