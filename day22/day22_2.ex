defmodule GridNode do
  defstruct [:size, :used, :avail]

  @doc """
  iex> GridNode.parse_node("/dev/grid/node-x0-y4     87T   66T    21T   75%")
  %{{0, 4} => %GridNode{avail: 21, size: 87, used: 66}}
  """
  def parse_node("/dev/grid/node-" <> node_text) do
    [x, y, size, used, avail] = Regex.run(~r/x(\d+)-y(\d+)\W+(\d+)T\W+(\d+)T\W+(\d+)T.+/, node_text, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    %{{x, y} => %GridNode{size: size, used: used, avail: avail}}
  end

end

defmodule Day22_2 do

  def get_storage_grid() do
    File.stream!("input.txt")
    |> Stream.drop(2)
    |> Stream.map(&GridNode.parse_node/1)
    |> Enum.reduce(&Map.merge/2)
  end

  def move_data(grid, from, to) do
    from_node = Map.fetch!(from)
    to_node = Map.fetch!(to)
    {new_from, new_to} = move_data(from_node, to_node)
    grid
    |> Map.merge(%{from => new_from, to => new_to})
  end
  def move_data(%{used: from_used} = from_node, %{used: to_used, avail: to_avail} = to_node)
      when from_used <= to_avail do
    %{from_node | used: 0}, %{to_node | used: to_used + from_used, avail: to_avail - from_used}}
  end

end
