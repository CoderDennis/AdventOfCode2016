defmodule Day22_2 do

  def get_storage_grid() do
    File.stream!("input.txt")
    |> Stream.drop(2)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&GridNode.parse_node/1)
    |> Stream.map(&(%{GridNode.get_coord(&1) => &1}))
    |> Enum.reduce(&Map.merge/2)
  end

end

defmodule GridNode do
  defstruct [:x, :y, :size, :used, :avail]

  @doc """
  iex> GridNode.parse_node("/dev/grid/node-x0-y4     87T   66T    21T   75%")
  %GridNode{avail: 21, size: 87, used: 66, x: 0, y: 4}
  """
  def parse_node("/dev/grid/node-" <> node_text) do
    [x, y, size, used, avail] = Regex.run(~r/x(\d+)-y(\d+)\W+(\d+)T\W+(\d+)T\W+(\d+)T.+/, node_text, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    %GridNode{x: x, y: y, size: size, used: used, avail: avail}
  end

  def get_coord(%GridNode{x: x, y: y}), do: {x, y}

end
