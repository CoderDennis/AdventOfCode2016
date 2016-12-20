defmodule Day19 do
  require Integer

  @doc """
  iex> Day19.run(5)
  3

  iex> Day19.run(10)
  5

  iex> Day19.run(11)
  7
  """
  def run(elf_count) do
    1..elf_count
    |> Enum.into([])
    |> drop_from_list(false)
  end

  def drop_from_list([elf], _drop_first), do: elf
  def drop_from_list(elves, false) do
    [0 | elves]
    # |> IO.inspect
    |> Enum.drop_every(2)
    |> drop_from_list(even_length?(elves))
  end
  def drop_from_list(elves, true) do
    elves
    # |> IO.inspect
    |> Enum.drop_every(2)
    |> drop_from_list(even_length?(elves))
  end

  defp even_length?(list) when Integer.is_even(length(list)), do: true
  defp even_length?(_), do: false

end