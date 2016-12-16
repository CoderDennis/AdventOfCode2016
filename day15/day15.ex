defmodule Day15 do

  def time_to_press_button(filename \\ "sample.txt") do
    discs = File.stream!(filename)
    |> Enum.map(&parse_input_line/1)
    IO.inspect discs
    Stream.iterate(0, &(&1+1))
    |> Enum.take_while(&(!all_slots_hit_from_start_time(&1, discs)))
  end

  @doc """
  iex> Day15.parse_input_line("Disc #1 has 13 positions; at time=0, it is at position 11.")
  {1, 13, 11}
  """
  def parse_input_line(line) do
    [ _, disc, positions, current ] = 
      Regex.run(~r/Disc #(\d) has (\d+) positions; at time=0, it is at position (\d+)./, line)
    { disc |> String.to_integer, 
      positions |> String.to_integer, 
      current |> String.to_integer }
  end

  def all_slots_hit_from_start_time(start_time, discs) do
    IO.inspect start_time
    discs
    |> Enum.all?(&(hits_slot_from_start_time(start_time, &1)))
  end

  @doc """
  iex> Day15.hits_slot_from_start_time(0, {1, 5, 4})
  true

  iex> Day15.hits_slot_from_start_time(4, {1, 5, 4})
  false

  iex> Day15.hits_slot_from_start_time(5, {1, 5, 4})
  true

  iex> Day15.hits_slot_from_start_time(0, {2, 2, 1})
  false

  iex> Day15.hits_slot_from_start_time(5, {2, 2, 1})
  true
  """
  def hits_slot_from_start_time(start_time, {disc, positions, current}) do
    rem((start_time + disc + current), positions) == 0
  end

end