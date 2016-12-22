defmodule Node do
  defstruct [:name, :size, :used, :avail]
end

defmodule Day22 do

  def count_viable_pairs() do
    File.stream!("input.txt")
    |> Stream.drop(2)
    |> Enum.map(&parse_node/1)
    |> count_viable_pairs
    |> MapSet.new
    |> MapSet.size
  end

  def count_viable_pairs(nodes) do
    for a <- nodes,
        b <- nodes,
        a.name != b.name,
        a.used > 0,
        a.used <= b.avail,
        do: [a.name, b.name] |> Enum.sort |> List.to_tuple
  end

  def parse_node("/dev/grid/node-" <> <<name::bytes-size(8)>> <> <<size::bytes-size(4)>> <> "T " <> <<used::bytes-size(4)>> <> "T  " <> <<avail::bytes-size(4)>> <> _) do
    %Node{name:  name  |> String.trim,
          size:  size  |> String.trim |> String.to_integer,
          used:  used  |> String.trim |> String.to_integer,
          avail: avail |> String.trim |> String.to_integer}
  end

end
