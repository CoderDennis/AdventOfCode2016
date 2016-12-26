defmodule Day13 do
  require Integer

  def draw_sample() do
    draw_maze(9, 6, 7, 4, 10)
  end

  def draw_puzzle() do
    draw_maze(40, 50, 31, 39, 1352)
  end

  def run_part2() do
    AnswerCollector.start_link
    Pathfinder.start({1,1}, 0, 1352, MapSet.new([{1,1}]))
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

  def start(position, step_count, number, path) do
    {:ok, pid} = GenServer.start(__MODULE__, {position, step_count, number, path})
    GenServer.cast(pid, :go)
    {:ok, pid}
  end

  def handle_cast(:go, {_position, 50, _number, path} = state) do
    AnswerCollector.save_answer(path)
    {:stop, :normal, state}
  end
  def handle_cast(:go, {position, step_count, number, path} = state) do
    position
    |> possible_steps(number, path)
    |> move(step_count, number, path)
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

  def move([], _step_count, _number, path) do
    AnswerCollector.save_answer(path)
  end
  def move(steps, step_count, number, path) do
    steps
    |> Enum.each(&(Pathfinder.start(&1, step_count + 1, number, MapSet.put(path, &1))))
  end

end

defmodule AnswerCollector do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, MapSet.new, name: :answer)
  end

  def save_answer(path) do
    GenServer.cast(:answer, path)
  end

  def get() do
    GenServer.call(:answer, :get)
  end

  def reset() do
    GenServer.call(:answer, :reset)
  end

  def handle_cast(new_path, seen_path) do
    {:noreply, MapSet.union(seen_path, new_path)}
  end

  def handle_call(:get, _from, seen_path) do
    {:reply, MapSet.size(seen_path), seen_path}
  end
  def handle_call(:reset, _from, _) do
    {:reply, :ok, MapSet.new}
  end

end
