defmodule Day01_2 do
  @doc ~s"""
  Part Two adds
  > Easter Bunny HQ is actually at the first location you visit twice.

  # Examples

    iex> Day01_2.blocks_to_easter_bunny_hq_2("R8, R4, R4, R8")
    4

  """
  def blocks_to_easter_bunny_hq_2(instructions) do
    instructions
    |> String.split(", ")
    |> follow_instructions_until_second_visit({{0,0}, :north, MapSet.new})
    |> absolute_distance
  end

  defp follow_instructions_until_second_visit([instruction | rest], {position, direction, visited}) do
    {new_direction, distance} = turn(instruction, direction)
    case do_move(distance, {position, new_direction, visited}) do
      {:ok, state} -> follow_instructions_until_second_visit(rest, state)
      {:found, position} -> position
    end
  end

  defp do_move(0, state), do: {:ok, state}
  defp do_move(distance, {position, direction, visited}) do
    if MapSet.member?(visited, position) do
      {:found, position}
    else
      visited = MapSet.put(visited, position)
      position = move(position, direction)
      do_move(distance - 1, {position, direction, visited})
    end
  end

  defp turn("R" <> distance, :north), do: {:east , str_to_int(distance)}
  defp turn("R" <> distance, :east ), do: {:south, str_to_int(distance)}
  defp turn("R" <> distance, :south), do: {:west , str_to_int(distance)}
  defp turn("R" <> distance, :west ), do: {:north, str_to_int(distance)}

  defp turn("L" <> distance, :north), do: {:west , str_to_int(distance)}
  defp turn("L" <> distance, :west ), do: {:south, str_to_int(distance)}
  defp turn("L" <> distance, :south), do: {:east , str_to_int(distance)}
  defp turn("L" <> distance, :east ), do: {:north, str_to_int(distance)}

  defp str_to_int(str) do
    str
    |> String.strip
    |> String.to_integer
  end

  defp move({x, y}, :north), do: {x+1, y  }
  defp move({x, y}, :east ), do: {x  , y+1}
  defp move({x, y}, :south), do: {x-1, y  }
  defp move({x, y}, :west ), do: {x  , y-1}

  defp absolute_distance({x, y}), do: abs(x) + abs(y)
end

# iex> File.read!("input.txt")