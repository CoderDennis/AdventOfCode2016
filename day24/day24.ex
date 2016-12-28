defmodule Day24 do

  def run_example() do
    File.stream!("example.txt")
    |> parse_map
    |> Map.start_link
    GenServer.cast(AirDuctMap, :go)
  end

  def parse_map(text_lines) do
    text_lines
    |> Enum.with_index
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(&Map.merge/2)
  end

  def parse_line({line, y}) do
    line
    |> String.trim
    |> String.codepoints
    |> Enum.with_index
    |> Enum.map(fn {char, x} -> %{{x,y} => map_point(char)} end)
    |> Enum.reduce(&Map.merge/2)
  end

  def map_point("#"), do: :wall
  def map_point("."), do: :space
  def map_point(x), do: {:number, x}

end

defmodule AirDuctMap do
  use GenServer
  defstruct [:map, :locations, :shortest]

  def start_link(map) do
    GenServer.start_link(__MODULE__,
      %AirDuctMap{
        map: map,
        locations: get_number_locations(map),
        shortest: nil
        },
      name: __MODULE__)
  end

  def get_passages(coord) do
    GenServer.call(__MODULE__, {:passages, coord})
  end

  def record_answer(length) do
    GenServer.call(__MODULE__, {:answer, length})
  end

  def get_answer() do
    GenServer.call(__MODULE__, :get_answer)
  end

  def reached_all_number_locations?(path) do
    path_set = path |> MapSet.new
    GenServer.call(__MODULE__, :get_number_locations)
    |> MapSet.subset?(path_set)
  end

  defp get_number_locations(map) do
    map
    |> Enum.filter(fn
      {_key, {:number, _}} -> true
      _ -> false
    end)
    |> MapSet.new
  end

  def handle_call({:answer, length}, _from, %{shortest: nil} = state) do
    {:reply, :ok, %{state | shortest: length}}
  end
  def handle_call({:answer, length}, _from, %{shortest: nil} = state) when length < shortest do
    {:reply, :ok, %{state | shortest: length}}
  end
  def handle_call({:answer, _}, _from, state) do
    {:reply, :ok, state}
  end
  def handle_call(:get_answer, _from, %{shortest: answer} = state) do
    {:reply, answer, state}
  end
  def handle_call({:passages, coord}, _from, %{map: map} = state) do
    {:reply, get_non_wall_neighbors(map, coord), state}
  end

  def handle_cast(:go, state) do

  end

  defp get_non_wall_neighbors(map, {x, y}) do
    [{x, y-1}, {x, y+1},
     {x-1, y}, {x+1, y}]
    |> Enum.filter(&(Map.has_key?(map, &1))
    |> Enum.reject(&(Map.fetch!(map, &1) == :wall))
  end

end

defmodule Pathfinder do
  use GenServer

  def start()