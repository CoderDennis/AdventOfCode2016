defmodule Day02 do
  @buttons %{{-1,-1} => 1, {0, -1} => 2, {1, -1} => 3,
             {-1, 0} => 4, {0,  0} => 5, {1,  0} => 6,
             {-1, 1} => 7, {0,  1} => 8, {1,  1} => 9}

  def get_code() do
    File.stream!("input.txt")
    |> Enum.to_list
    |> Enum.map(&String.strip/1)
    |> get_code([], {0,0})
  end
  @doc ~s"""

  # Examples
  iex> Day02.get_code(["ULL", "RRDDD", "LURDL", "UUUUD"], [], {0,0})
  [1, 9, 8, 5]

  """
  def get_code([], digits, start_button), do: digits |> Enum.reverse
  def get_code([instruction | rest], digits, start_button) do
    button = get_digit(instruction, start_button)
    get_code(rest, [Map.fetch!(@buttons, button)|digits], button)
  end


  defp get_digit(instruction, start_button) do
    instruction
    |> String.codepoints
    |> get_button(start_button)
  end

  defp get_button([], button), do: button
  defp get_button([direction | rest], button) do
    get_button(rest, move(direction, button))
  end

  defp move("U", { x, -1}), do: {x  ,  -1}
  defp move("U", { x,  y}), do: {x  , y-1}
  defp move("D", { x,  1}), do: {x  ,   1}
  defp move("D", { x,  y}), do: {x  , y+1}
  defp move("L", {-1,  y}), do: { -1, y  }
  defp move("L", { x,  y}), do: {x-1, y  }
  defp move("R", { 1,  y}), do: {  1, y  }
  defp move("R", { x,  y}), do: {x+1, y  }
end