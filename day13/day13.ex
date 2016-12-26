defmodule Day13 do
  require Integer

  def draw_sample() do
    draw_maze(9, 6, 7, 4, 10)
  end

  def draw_puzzle() do
    draw_maze(40, 50, 31, 39, 1352)
  end

  def navigate_sample() do
    navigate({7, 4}, 10)
  end

  def navigate_puzzle() do
    navigate({31, 39}, 1352)
  end

  def navigate(goal, favorite_number) do
    AnswerCollector.start_link
    Pathfinder.start({1, 1}, goal, favorite_number, MapSet.new)
  end

  @doc ~s"""
  iex> Day13.wall_or_open_space(1, 0, 10)
  :wall

  iex> Day13.wall_or_open_space(1, 1, 10)
  :open_space
  """
  def wall_or_open_space(x, y, _) when x < 0 or y < 0, do: :invalid
  def wall_or_open_space(x, y, favorite_number) do
    (x*x + 3*x + 2*x*y + y + y*y + favorite_number)
    |> Integer.to_charlist(2)
    |> Enum.filter(&(&1 == ?1))
    |> Enum.count
    |> wall_or_open_space
  end

  defp wall_or_open_space(bit_count) when Integer.is_even(bit_count), do: :open_space
  defp wall_or_open_space(_), do: :wall

  defp draw_maze(width, height, goal_x, goal_y, favorite_number) do
    IO.write("   ")
    0..width
    |> Enum.each(&(IO.write("#{div(&1,10)}")))
    IO.write("\n   ")
    0..width
    |> Enum.each(&(IO.write("#{rem(&1,10)}")))
    (for y <- 0..height,
         x <- 0..width,
         do: {x, y})
    |> Enum.each(fn {x, y} ->
        if 0 == x do
          IO.write("\n#{y |> Integer.to_string |> String.rjust(2, ?0)} ")
        end
        if (x == goal_x && y == goal_y) do
          IO.write("X")
        else
          wall_or_open_space(x, y, favorite_number)
          |> display
          |> IO.write
        end
      end)
    IO.puts("")
  end

  defp display(:wall), do: "#"
  defp display(:open_space), do: "."

end

defmodule Pathfinder do
  use GenServer

  def start(position, goal, number, path) do
    {:ok, pid} = GenServer.start(__MODULE__, {position, goal, number, path})
    GenServer.cast(pid, :go)
    {:ok, pid}
  end

  def handle_cast(:go, {goal, goal, _number, path} = state) do
    AnswerCollector.save_answer(MapSet.size(path))
    {:stop, :normal, state}
  end
  def handle_cast(:go, {position, goal, number, path} = state) do
    position
    |> possible_steps(number, path)
    |> Enum.each(&(Pathfinder.start(&1, goal, number, MapSet.put(path, &1))))
    {:stop, :normal, state}
  end

  def possible_steps({x, y}, number, path) do
    [{x + 1, y},
     {x - 1, y},
     {x, y + 1},
     {x, y - 1}]
    |> Enum.filter(&(space_not_in_path?(&1, number, path)))
  end

  def space_not_in_path?({x, y} = position, number, path) do
    if MapSet.member?(path, position) do
      false
    else
      Day13.wall_or_open_space(x, y, number) == :open_space
    end
  end

end

defmodule AnswerCollector do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, 0, name: :answer)
  end

  def save_answer(length) do
    GenServer.cast(:answer, length)
  end

  def get() do
    GenServer.call(:answer, :get)
  end

  def reset() do
    GenServer.call(:answer, :reset)
  end

  def handle_cast(length, 0) do
    {:noreply, length}
  end
  def handle_cast(length, shortest) when length < shortest do
    {:noreply, length}
  end
  def handle_cast(_, state) do
    {:noreply, state}
  end

  def handle_call(:get, _from, length) do
    {:reply, length, length}
  end
  def handle_call(:reset, _from, _) do
    {:reply, :ok, 0}
  end

end
