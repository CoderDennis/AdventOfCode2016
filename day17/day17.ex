defmodule Day17 do

  def run(passcode) do
    AnswerCollector.start_link()
    AnswerCollector.reset()
    Pathfinder.start_link({0,0}, passcode)
  end

  def get_answer() do
    GenServer.call(:answer, :get)
  end

  @doc """
  iex> Day17.get_hash("hijkl") |> String.starts_with?("ced9")
  true

  iex> Day17.get_hash("hijklD") |> String.starts_with?("f2bc")
  true

  iex> Day17.get_hash("hijklDR") |> String.starts_with?("5745")
  true
  """
  def get_hash(passcode) do
    :crypto.hash(:md5, passcode)
    |> Base.encode16
    |> String.downcase
  end

end

defmodule AnswerCollector do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, {0, ""}, name: :answer)
  end

  def save_answer(passcode) do
    GenServer.cast(:answer, {String.length(passcode), passcode})
  end

  def reset() do
    GenServer.call(:answer, :reset)
  end

  def handle_cast({length, passcode}, {0, _}) do
    {:noreply, {length, passcode}}
  end
  def handle_cast({length, passcode}, {longest, _}) when length > longest do
    {:noreply, {length, passcode}}
  end
  def handle_cast(_, state) do
    {:noreply, state}
  end

  def handle_call(:get, _from, {length, _} = state) do
    {:reply, length - 8, state}
  end
  def handle_call(:reset, _from, _) do
    {:reply, :ok, {0, ""}}
  end

end

defmodule Pathfinder do
  use GenServer

  @doc """
  Only the first four characters of the hash are used; they represent, respectively, 
  the doors up, down, left, and right from your current position. 
  Any b, c, d, e, or f means that the corresponding door is open; 
  any other character (any number or a) means that the corresponding door 
  is closed and locked.
  """

  def start_link(position, passcode) do
    {:ok, pid} = GenServer.start_link(__MODULE__,
      {position, passcode})
    GenServer.cast(pid, :go)
    {:ok, pid}
  end

  def handle_cast(:go, {{3,3}, passcode} = state) do
    #IO.puts "#{String.length passcode}:#{passcode}"
    AnswerCollector.save_answer(passcode)
    {:noreply, state, :hibernate}
  end
  def handle_cast(:go, {position, passcode} = state) do
    passcode
    |> Day17.get_hash
    |> String.codepoints
    |> Enum.take(4)
    |> Enum.with_index()
    |> Enum.filter(fn {code, _} -> door_open?(code) end)
    |> Enum.each(fn {_, door} -> move(door, position, passcode) end)
    {:noreply, state}
  end

  @open_chars "bcdef" |> String.codepoints

  defp door_open?(code) when code in @open_chars, do: true
  defp door_open?(_), do: false

  # Up
  defp move(0, {_x, 0}, _passcode), do: :ok
  defp move(0, {x, y}, passcode), do: Pathfinder.start_link({x, y-1}, passcode <> "U")
  # Down
  defp move(1, {_x, 3}, _passcode), do: :ok
  defp move(1, {x, y}, passcode), do: Pathfinder.start_link({x, y+1}, passcode <> "D")
  # Left
  defp move(2, {0, _y}, _passcode), do: :ok
  defp move(2, {x, y}, passcode), do: Pathfinder.start_link({x-1, y}, passcode <> "L")
  # Right
  defp move(3, {3, _y}, _passcode), do: :ok
  defp move(3, {x, y}, passcode), do: Pathfinder.start_link({x+1, y}, passcode <> "R")

end