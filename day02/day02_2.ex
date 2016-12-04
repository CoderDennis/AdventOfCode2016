defmodule Day02_2 do
  @buttons %{                                 {0, -2} => '1',
                             {-1, -1} => '2', {0, -1} => '3', {1, -1} => '4',
             {-2, 0} => '5', {-1,  0} => '6', {0,  0} => '7', {1,  0} => '8', {2, 0} => '9',
                             {-1,  1} => 'A', {0,  1} => 'B', {1,  1} => 'C',
                                              {0,  2} => 'D'}

  def get_code() do
    File.stream!("input.txt")
    |> Enum.to_list
    |> Enum.map(&String.strip/1)
    |> get_code([], {-2,0})
  end
  @doc ~s"""

  # Examples
  iex> Day02_2.get_code(["ULL", "RRDDD", "LURDL", "UUUUD"], [], {-2,0})
  ['5', 'D', 'B', '3']

  """
  def get_code([], digits, _), do: digits |> Enum.reverse
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
    get_button(rest, move_and_validate(direction, button))
  end

  defp move_and_validate(direction, button) do
    new_button = move(direction, button)
    if Map.has_key?(@buttons, new_button) do
      new_button
    else
      button
    end
  end

  defp move("U", { x,  y}), do: {x  , y-1}
  defp move("D", { x,  y}), do: {x  , y+1}
  defp move("L", { x,  y}), do: {x-1, y  }
  defp move("R", { x,  y}), do: {x+1, y  }
end