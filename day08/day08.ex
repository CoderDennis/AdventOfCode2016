defmodule Day08 do

  def puzzle_answer() do
    size = {50,6}
    {:ok, screen_pid} = Day08.Screen.start_link(size)
    File.stream!("input.txt")
    |> Stream.map(&parse_instruction/1)
    |> Enum.each(&(GenServer.call(screen_pid, &1)))
    GenServer.call(screen_pid, :get_pixels)
    |> display_pixels(size)
  end

  def sample_screen() do
    size = {7,3}
    {:ok, screen_pid} = Day08.Screen.start_link(size)
    File.stream!("sample.txt")
    |> Stream.map(&parse_instruction/1)
    |> Enum.each(&(GenServer.call(screen_pid, &1)))
    GenServer.call(screen_pid, :get_pixels)
    |> display_pixels(size)
  end

  def display_pixels(pixels, {width, height}) do
    (for y <- 0..height-1,
         x <- 0..width-1,
         do: {x, y})
    |> Enum.each(fn {x, y} ->
        if 0 == x do
          IO.puts("")
        end
        if MapSet.member?(pixels, {x, y}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end)
  end

  @doc ~s"""
  iex> Day08.parse_instruction("rect 3x2")
  {:rect, {3, 2}}
  """
  def parse_instruction("rect " <> instruction) do
    {:rect, get_size_values(instruction)}
  end
  def parse_instruction("rotate column x=" <> instruction) do
    {:rotate_column, get_rotate_values(instruction)}
  end
  def parse_instruction("rotate row y=" <> instruction) do
    {:rotate_row, get_rotate_values(instruction)}
  end

  defp get_size_values(instruction) do
    Regex.run(~r/(\d+)x(\d+)/, instruction)
    |> regex_results_to_tuple
  end

  @doc ~s"""
  iex> Day08.get_rotate_values("1 by 1")
  {1, 1}

  iex> Day08.get_rotate_values("42 by 5")
  {42, 5}
  """
  def get_rotate_values(instruction) do
    Regex.run(~r/(\d+) by (\d+)/, instruction)
    |> regex_results_to_tuple
  end

  defp regex_results_to_tuple(re) do
    re
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

end

defmodule Day08.Screen do
  use GenServer

  ## Client API

  def start_link({width, height}) do
    GenServer.start_link(__MODULE__, {width, height})
  end

  ## Server Callbacks

  def init({_width, _height} = size) do
    {:ok, {[], size}}
  end

  def handle_call({:rect, {width,height}}, _from, {pixels, size}) do
    existing_pixels = get_pixel_positions(pixels)
    new_pixels = (for x <- 0..width-1,
                      y <- 0..height-1,
                      !MapSet.member?(existing_pixels, {x,y}),
                      do: {x,y})
    |> Enum.map(&add_pixel/1)
    |> Enum.concat(pixels)
    {:reply, :ok, {new_pixels, size}}
  end

  def handle_call({:rotate_column, {column, count}}, _from, {pixels, {_, height}} = state) do
    pixels
    |> Enum.each(&(GenServer.call(&1, {:rotate_column, column, count, height})))
    {:reply, :ok, state}
  end

  def handle_call({:rotate_row, {row, count}}, _from, {pixels, {width, _}} = state) do
    pixels
    |> Enum.each(&(GenServer.call(&1, {:rotate_row, row, count, width})))
    {:reply, :ok, state}
  end

  def handle_call(:get_pixels, _from, {pixels, _} = state) do
    {:reply, get_pixel_positions(pixels), state}
  end

  defp add_pixel(position) do
    {:ok, pixel} = Day08.Pixel.start_link(position)
    pixel
  end

  defp get_pixel_positions(pixels) do
    pixels
    |> Enum.map(&Day08.Pixel.get_position/1)
    |> MapSet.new
  end
end

defmodule Day08.Pixel do
  use GenServer

  ## Client API

  def start_link({x,y}) do
    GenServer.start_link(__MODULE__, {x,y}, [])
  end

  def get_position(pixel) do
    GenServer.call(pixel, :get_position)
  end

  ## Server Callbacks

  def init(start_position) do
    {:ok, start_position}
  end

  def handle_call(:get_position, _from, position) do
    {:reply, position, position}
  end

  def handle_call({:rotate_column, x, count, height}, _from, {x, y}) do
    position = {x, rotate_y(y, count, height)}
    {:reply, position, position}
  end

  def handle_call({:rotate_row, y, count, width}, _from, {x, y}) do
    position = {rotate_x(x, count, width), y}
    {:reply, position, position}
  end

  def handle_call(_, _from, position) do
    {:reply, position, position}
  end

  defp rotate_x(x, count, width), do: rem(x + count, width)

  defp rotate_y(y, count, height), do: rem(y + count, height)
end